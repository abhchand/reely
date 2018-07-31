class CollectionsController < ApplicationController
  layout "with_responsive_navigation"

  before_action :collection, only: :show

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    @photos ||= collection.photos.order(:taken_at)
    @photo_count = @photos.count

    @date_range_label = DateRangeLabelService.call(@photos)
  end

  private

  def collection
    @collection ||=
      Collection.find_by_synthetic_id(params[:id]).tap do |c|
        redirect_to(root_path) if c.blank?
      end
  end
end
