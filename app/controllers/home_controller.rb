class HomeController < ApplicationController
  layout "with_responsive_navigation"

  def index
    # rubocop:disable MemoizedInstanceVariableName
    @photos ||= Photo.all.order(taken_at: :desc)
    # rubocop:enable MemoizedInstanceVariableName
  end
end
