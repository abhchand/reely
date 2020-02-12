class BundleFilesJob < ApplicationWorker
  TTL = 1.hour.freeze

  sidekiq_options retry: 3

  def perform(collection_id, uuid)
    @uuid = uuid
    @collection = Collection.find(collection_id)
    @download_dir = Rails.configuration.x.default_download_dir.join(@uuid)

    return if @collection.photos.count.zero?

    create_download_dir
    download_files
    bundle_files

    schedule_deletion_job
  end

  private

  def create_download_dir
    FileUtils.mkdir_p(@download_dir)
  end

  def download_files
    @collection.photos.with_attached_source_file.each do |photo|
      photo.source_file.open do |file|
        filename = photo.source_file_blob.filename.to_s
        FileUtils.cp(file.path, @download_dir.join(filename))
      end
    end
  end

  def bundle_files
    cmd = ["zip", "--quiet", bundle_name, "*"].join(" ")

    Dir.chdir(@download_dir) do
      raise unless system(cmd)
    end
  end

  def bundle_name
    [@collection.name.gsub(" ", "-"), "zip"].join(".").shellescape
  end

  def schedule_deletion_job
    DeleteFileBundleJob.perform_in(TTL, @uuid)
  end
end
