class AdminController < ApplicationController
  layout 'with_responsive_navigation'

  before_action :admin_only
  before_action { @use_packs << 'admin' }

  def index; end

  private

  def admin_only
    return if can?(:read, :admin)

    respond_to do |format|
      format.json { render json: { error: 'Access Denied' }, status: 401 }
      format.html { redirect_to(root_path) }
    end
  end
end
