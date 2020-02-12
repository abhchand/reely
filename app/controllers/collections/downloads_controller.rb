class Collections::DownloadsController < ApplicationController
  include CollectionHelper

  ZIP_FILE_MIME_TYPE = "application/octet-stream".freeze

  skip_before_action :authenticate_user!

  before_action :ensure_json_request, only: %i[create status]
  before_action :set_shared_collection
  before_action :only_if_sharing_enabled

  def show
    if download_path.present?
      send_file(download_path, type: ZIP_FILE_MIME_TYPE)
    else
      flash[:error] = t(".not_found")
      redirect_to root_path
    end
  end

  def create
    # Generate an id and set it directly
    @decrypted_id = SecureRandom.hex

    if collection.photos.any?
      BundleFilesJob.perform_async(collection.id, decrypted_id)

      respond_to do |format|
        format.json { render json: { id: encrypted_id }, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render json: { error: "Empty collection" }, status: 403 }
      end
    end
  end

  def status
    json = {
      download: {
        isComplete: download_path.present?,
        url: (download_url if download_path.present?)
      }
    }

    respond_to do |format|
      format.json { render json: json, status: 200 }
    end
  end

  private

  def download_path
    return if decrypted_id.blank?

    @download_path ||= begin
      path = Rails.configuration.x.default_download_dir.join(decrypted_id)
      bundle_path = Dir["#{path}/*.zip"].first

      Pathname.new(bundle_path) if bundle_path
    end
  end

  def download_url
    collection_download_url(
      collection_id: collection.share_id,
      id: encrypted_id
    )
  end

  def decrypted_id
    @decrypted_id ||=
      verifier.verified(params[:id] || params[:download_id])
  end

  def encrypted_id
    verifier.generate(@decrypted_id)
  end
end
