class ContentImportJob < ApplicationWorker
  def perform(owner_id, filepath)
    @filepath = Pathname.new(filepath)
    @owner = User.find(owner_id)
    @job_id = SecureRandom.hex

    return unless @filepath.exist?

    import! unless duplicate_file?

    remove_file
    remove_dir
  end

  private

  def log_tag
    [self.class.name, @job_id].map { |t| "[#{t}]" }.join
  end

  def log_start
    Rails.logger.info("#{log_tag} Importing: #{@filepath}")
  end

  def log_missing_file
    Rails.logger.error("#{log_tag} Missing File")
  end

  def log_duplicate
    Rails.logger.error("#{log_tag} Duplicate File")
  end

  def import!
    ActiveRecord::Base.transaction do
      photo = Photo.create!(owner: @owner, exif_data: exif_data)
      photo.source_file.attach(io: file_io, filename: @filepath.basename)

      Rails.logger.info("#{log_tag} Created Photo #{photo.id}")
    end
  end

  # Check whether the file is a duplicate by comparing it to the checksums
  # of existing files for the same owner
  def duplicate_file?
    safe_checksum = ActiveRecord::Base.connection.quote(checksum)

    ActiveRecord::Base.connection.execute(
      <<-SQL
      SELECT
        asb.id
      FROM active_storage_blobs asb
      JOIN active_storage_attachments asa
        ON asa.blob_id = asb.id
      JOIN photos p
        ON asa.record_type = 'Photo' and asa.record_id = p.id
      WHERE p.owner_id = #{@owner.id}
        AND asb.checksum = #{safe_checksum}
      LIMIT 1
      SQL
    ).to_a.any?
  end

  # ActiveStorage already computes a checksum which it stores in the
  # ActiveStorage::Blob record. Re-use that logic here so we don't have to
  # implement and store something separate
  def checksum
    @checksum ||= ActiveStorage::Blob.new.send(
      :compute_checksum_in_chunks,
      file_io
    )
  end

  def file_io
    @file_io ||= File.open(@filepath)
  end

  def exif_data
    @exif_data ||= Exiftool.new(@filepath).to_hash
  end

  def remove_file
    Rails.logger.info("#{log_tag} Removing file #{@filepath}")
    FileUtils.rm(@filepath)
  end

  def remove_dir
    dir = @filepath.dirname

    Rails.logger.info("#{log_tag} Removing dir #{dir}")
    FileUtils.rm_rf(dir) if dir.empty?
  end
end
