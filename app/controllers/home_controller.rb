class HomeController < ApplicationController
  layout "with_responsive_navigation"

  def index
    @photos ||= Photo.all.order(taken_at: :desc)
  end
end
