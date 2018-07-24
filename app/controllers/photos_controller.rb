class PhotosController < ApplicationController
  layout "with_responsive_navigation"

  def index
    # rubocop:disable MemoizedInstanceVariableName
    @photos ||= Photo.where(owner: current_user).order(taken_at: :desc)
    # rubocop:enable MemoizedInstanceVariableName
  end
end
