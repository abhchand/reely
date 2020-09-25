class ContentImportQueueingJob < ApplicationWorker
  # Finds content files to import into Reely by looking through files in
  # the import directory.
  #
  # This job queues up a series of `ContentImportJob` workers, each of which
  # is repsonsible for importing a single file.
  #
  # The expected structure of the import dir is that the top level is
  # namespaced by the owner's (user's) `synthetic_id`
  #
  # /
  # |-- HXtEWGN7HEuUrjsZ5u4WfWytQUwZ/
  #   |-- ...
  #   |-- ...
  # |-- VvMZLGSNH1g4RGpNSjGxVUq1SSmJ/
  #   |-- ...
  #   |-- ...
  # |-- Zo6aWBi5MZPxkUUbH3M8M6cPTK7t/
  #   |-- ...
  #   |-- ...
  #
  # Files within each owner's directory can follow any structure. The import
  # process will look at all files, even those in nested subdirectories.
  #
  # Reely will attempt to guess the file's content type based on its magic
  # number and/or its filename extension.
  #
  # Invalid owner directories or invalid content types will not be imported into
  # the app.
  #
  # Valid files will be imported into the app and then deleted from the
  # import directory. Any remaining empty directories will also be removed
  # as part of the cleanup process.
  #
  def perform
    within_import_dir do
      each_owner do |owner|
        each_file_for(owner) do |filepath|
          next unless image?(filepath)
          ContentImportJob.perform_async(owner.id, filepath.to_s)
        end
      end
    end
  end

  private

  # rubocop:disable Lint/UnusedMethodArgument

  def import_dir
    @import_dir ||=
      ENV['REELY_IMPORT_DIR'] || Rails.configuration.x.default_import_dir
  end

  def within_import_dir(&block)
    Dir.chdir(import_dir) { yield }
  end

  def each_owner(&block)
    User.where(synthetic_id: directories).find_each { |owner| yield(owner) }
  end

  def each_file_for(owner, &block)
    Dir.glob("#{owner.synthetic_id}/**/*").each do |file|
      file = to_absolute(file)
      yield(file) unless file.directory?
    end
  end

  def directories
    Dir.glob('*').select { |f| Pathname.new(f).directory? }
  end

  def to_absolute(filepath)
    Pathname.new(import_dir).join(filepath)
  end

  def image?(filepath)
    mime_type(filepath).start_with?('image')
  end

  def mime_type(filepath)
    Marcel::MimeType.for(filepath, name: filepath.basename.to_s)
  end

  # rubocop:enable Lint/UnusedMethodArgument
end
