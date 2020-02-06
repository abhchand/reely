class CollectionsController < ApplicationController
  include CollectionHelper

  layout "with_responsive_navigation"

  # rubocop:disable Metrics/LineLength
  before_action :ensure_json_request, only: %i[update add_photos remove_photos destroy]
  before_action :set_collection, only: %i[show update add_photos remove_photos destroy]
  before_action :only_if_my_collection, only: %i[show update add_photos remove_photos destroy]
  # rubocop:enable Metrics/LineLength

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    @photos ||= collection.photos.order(:taken_at)

    @photo_count = @photos.count
    @date_range_label = DateRangeLabelService.call(@photos)

    @collections = current_user.collections.order(created_at: :desc)
  end

  def create
    @collection = Collection.new(
      owner: current_user,
      name: collections_create_params["name"]
    )
    status, json = @collection.save ? [200, @collection] : [400, {}]

    respond_to do |format|
      format.json { render json: json, status: status }

      format.html do
        if status == 200
          redirect_to collection_path(@collection)
        else
          flash[:error] = t("collections.create.error")
          redirect_to root_path
        end
      end
    end
  end

  def update
    @collection.attributes = collections_update_params
    status = @collection.save ? 200 : 400

    respond_to do |format|
      format.json { render json: {}, status: status }
    end
  end

  def destroy
    status = @collection.destroy ? 200 : 400

    respond_to do |format|
      format.json { render json: {}, status: status }
    end
  end

  def add_photos
    service = AddPhotosToCollection.call(
      collection: @collection,
      params: collections_add_or_remove_photos_params
    )

    status = service.success? ? 200 : 400

    respond_to do |format|
      format.json { render json: {}, status: status }
    end
  end

  def remove_photos
    service = RemovePhotosFromCollection.call(
      collection: @collection,
      params: collections_add_or_remove_photos_params
    )

    status = service.success? ? 200 : 400
    meta = service.success? ? service.meta : {}

    respond_to do |format|
      format.json { render json: meta, status: status }
    end
  end

  private

  def collections_create_params
    params.require(:collection).permit(
      :name
    )
  end

  def collections_update_params
    params.require(:collection).permit(
      :name
    )
  end

  def collections_add_or_remove_photos_params
    params.require(:collection).permit(
      photo_ids: []
    )
  end
end
