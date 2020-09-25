# ActiveStorage provides a stable public URL for an attachment that internally
# redirects to a temporary URL. The flow is as follows:
#
#   1. `url_for` for some model with an attachment will generate a stable URL
#      that points to `ActiveStorage::RepresentationsController`
#
#   2. The controller calls the Service (Local, S3, Google Cloud, etc..)
#      and generates a redirect to a temporary URL that expires soon.
#
#   3. In the specific case of the `DiskService`, ActiveStorage provides the
#      `ActiveStorage::DiskController` which verifies the temporary URL params
#      and serves the file
#
# This flow poses a few problems for Reely:
#
# 1. We don't want to redirect for every image request. It introduces a lag
#    over hundreds of served images
#
# 2. We only care about the DiskService (not serving images from S3, etc..) so
#    we don't need the flexibility of providing a stable URL in front of a
#    temporary URL that points to a service with an expiration.
#
# 3. ActiveStorage lazily processes (i.e. transforms) variants inline when the
#    file is being served. We want to enforce that all our images our processed
#    ahead of time.
#
# 4. ActiveStorage URLs are not pretty. This is a lower priority vanity
#    requirement but Reely is built around being simple and user friendly, and
#    having clean direct routes to image files is valuable.
#
# So we build our own controller here that bypasses a lot of the above logic
# while reusing the `DiskController` logic where possible.
#

class RawPhotosController < ActiveStorage::DiskController
  before_action :ensure_blob_and_file_present

  def show
    if serving_files_from_disk?
      serve_file(path, content_type: content_type, disposition: disposition)
    else
      redirect_to(blob_or_variant.service_url)
    end
  end

  private

  def serving_files_from_disk?
    ActiveStorage::Blob.service.class.name ==
      'ActiveStorage::Service::DiskService'
  end

  def ensure_blob_and_file_present
    redirect_to(root_path) if blob_or_variant.nil? || !processed?
  end

  def blob_or_variant
    @blob_or_variant ||=
      begin
        direct_access_key = ActiveRecord::Base.connection.quote(params[:id])
        blob_or_variant =
          ActiveStorage::Blob.find_by_sql(<<-SQL)
        SELECT
          asb.key,
          asb.filename,
          asb.content_type
        FROM active_storage_blobs asb
        JOIN active_storage_attachments asa
          ON asa.blob_id = asb.id
        JOIN photos p
          ON asa.record_type = 'Photo' and asa.record_id = p.id
        WHERE p.direct_access_key = #{
            direct_access_key
          }
        LIMIT 1
        SQL.first

        return if blob_or_variant.nil?
        return blob_or_variant if params[:size].blank? || !transformations

        blob_or_variant.variant(transformations)
      end
  end

  def transformations
    Photo::SOURCE_FILE_SIZES[params[:size].downcase.to_sym]
  end

  def variant?
    blob_or_variant.is_a?(ActiveStorage::Variant)
  end

  def processed?
    return true unless variant?
    blob_or_variant.send(:processed?)
  end

  def path
    disk_service.path_for(blob_or_variant.key)
  end

  def content_type
    blob_or_variant.send(:content_type)
  end

  def disposition
    extension = blob_or_variant.send(:filename).extension_without_delimiter
    filename = [params[:id], extension].join('.')

    "inline; filename=\"#{filename}\"; filename*=UTF-8''#{filename}"
  end
end
