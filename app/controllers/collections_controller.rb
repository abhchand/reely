class CollectionsController < ApplicationController
  layout "with_responsive_navigation"

  before_action :ensure_xhr_only, only: %i[create update destroy]
  before_action :collection, only: %i[show update destroy]
  before_action :only_my_collection, only: %i[show update destroy]

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    @photos ||= collection.photos.order(:taken_at)
    @photo_count = @photos.count

    @date_range_label = DateRangeLabelService.call(@photos)
  end

  def create
    @collection = Collection.new(
      owner: current_user,
      name: collections_create_params["name"]
    )
    status, json = @collection.save ? [200, @collection] : [400, {}]

    respond_to do |format|
      format.json { render json: json, status: status }
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

  private

  def collection
    @collection ||=
      Collection.find_by_synthetic_id(params[:id]).tap do |c|
        handle_collection_not_found if c.blank?
      end
  end

  def only_my_collection
    return if current_user.owns_collection?(@collection)
    handle_not_my_collection
  end

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

  def handle_collection_not_found
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end

  def handle_not_my_collection
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end
end
