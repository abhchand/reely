class Collections::SharingDisplayController < ApplicationController
  include CollectionHelper

  layout 'application'

  before_action :set_shared_collection
  skip_before_action :authenticate_user!

  def show
    @photos ||= collection.photos.order(:taken_at)
    @photo_count = @photos.count

    @date_range_label = DateRangeLabelService.call(@photos)
  end
end
