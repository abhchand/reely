class PhotosController < ApplicationController
  layout "with_responsive_navigation"

  def index
    @photos ||= Photo.where(owner: current_user).order(taken_at: :desc)

    @photo_count = @photos.count

    @collections = current_user.collections.order(created_at: :desc)
  end
end
