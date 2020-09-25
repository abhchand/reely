class PhotosController < ApplicationController
  layout 'with_responsive_navigation'

  MAX_FILE_UPLOAD_COUNT = 25

  before_action :ensure_json_request, only: %i[create]
  before_action :include_pack_file_upload, only: %i[new]

  def index
    @photos ||= Photo.where(owner: current_user).order(taken_at: :desc)

    @photo_count = @photos.count

    @collections = current_user.collections.order(created_at: :desc)
  end

  def new; end

  def create
    import.log.tap { |msg| Rails.logger.debug(msg) if msg }

    respond_to do |format|
      if import.success?
        format.json { render json: { paths: { tile: tile_path } }, status: 200 }
      else
        format.json { render json: { error: import.error }, status: 403 }
      end
    end
  end

  private

  def include_pack_file_upload
    @use_packs << 'file-upload'
  end

  def create_params
    params.require(:photo).permit(:source_file)
  end

  def import
    @import ||=
      Photos::ImportService.call(
        owner: current_user,
        filepath: create_params[:source_file].tempfile.path,
        filename: create_params['source_file'].original_filename
      )
  end

  def tile_path
    @tile_path ||=
      PhotoPresenter.new(import.photo, view: nil).source_file_path(size: :tile)
  end
end
