class Photos::ImportService
  include Interactor
  include ActionView::Helpers::NumberHelper

  # This should match any front end validation default
  MAX_FILE_SIZE = 15.megabytes.freeze

  def call
    @i18n_prefix = 'photos.import_service'

    case
    when !file_exists?
      handle_missing_file
    when !valid_file_size?
      handle_invalid_file_size
    when !valid_content_type?
      handle_invalid_content_type
    when duplicate?
      handle_duplicate_image
    when !create_photo
      handle_failed_creation
    end
  end

  private

  def owner
    @owner ||= context.owner
  end

  def filepath
    @filepath ||= Pathname.new(context.filepath)
  end

  def max_file_size
    @max_file_size ||= context.max_file_size || MAX_FILE_SIZE
  end

  def file_exists?
    filepath.exist?
  end

  def valid_file_size?
    File.size(filepath) <= max_file_size
  end

  def valid_content_type?
    Marcel::MimeType.for(filepath, name: filepath.basename.to_s).start_with?(
      'image'
    )
  end

  def duplicate?
    # Check whether the file is a duplicate by comparing it to the checksums
    # of existing files for the same owner

    safe_checksum = ActiveRecord::Base.connection.quote(checksum)

    response =
      ActiveRecord::Base.connection.execute(<<-SQL)
        SELECT
          asb.id
        FROM active_storage_blobs asb
        JOIN active_storage_attachments asa
          ON asa.blob_id = asb.id
        JOIN photos p
          ON asa.record_type = 'Photo' and asa.record_id = p.id
        WHERE p.owner_id = #{
        owner.id
      }
          AND asb.checksum = #{safe_checksum}
        LIMIT 1
      SQL

    response.to_a.any?
  end

  def create_photo
    ActiveRecord::Base.transaction do
      context.photo = Photo.create!(owner: @owner, exif_data: exif_data)
      context.photo.source_file.attach(
        io: file_io, filename: context.filename || filepath.basename
      )
    end
  rescue StandardError
    false
  end

  def handle_missing_file
    context.fail!(
      log: "#{log_tags} Missing file",
      error: I18n.t("#{@i18n_prefix}.generic_error")
    )
  end

  def handle_invalid_file_size
    context.fail!(
      log: "#{log_tags} File too large",
      error:
        I18n.t(
          "#{@i18n_prefix}.invalid_file_size",
          max_file_size: number_to_human_size(max_file_size)
        )
    )
  end

  def handle_invalid_content_type
    context.fail!(
      log: "#{log_tags} Invalid content type",
      error: I18n.t("#{@i18n_prefix}.invalid_content_type")
    )
  end

  def handle_duplicate_image
    context.fail!(
      log: "#{log_tags} Duplicate image",
      error: I18n.t("#{@i18n_prefix}.duplicate_image")
    )
  end

  def handle_failed_creation
    context.fail!(
      log: "#{log_tags} Photo errors: #{context.photo.errors.messages}",
      error: I18n.t("#{@i18n_prefix}.generic_error")
    )
  end

  def log_tags
    "[#{self.class.name}] [#{@job_id}]"
  end

  def checksum
    # ActiveStorage already computes a checksum which it stores in the
    # ActiveStorage::Blob record. Re-use that logic here so we don't have to
    # implement and store something separate
    @checksum ||=
      ActiveStorage::Blob.new.send(:compute_checksum_in_chunks, file_io)
  end

  def file_io
    @file_io ||= File.open(filepath)
  end

  def exif_data
    @exif_data ||= Exiftool.new(filepath).to_hash
  end
end
