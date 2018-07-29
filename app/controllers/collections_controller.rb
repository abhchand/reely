class CollectionsController < ApplicationController
  layout "with_responsive_navigation"

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def shared
  end
end
