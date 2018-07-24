class SiteController < ApplicationController
  skip_before_action :ensure_authentication

  def index
    redirect_to photos_path if current_user
    @dest = params[:dest]
  end
end
