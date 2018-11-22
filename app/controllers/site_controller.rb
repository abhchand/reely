class SiteController < ApplicationController
  skip_before_action :ensure_authentication

  def index
    puts(current_user ? "CURRENT USER EXISTS" : "CURRENT USER NIL")
    redirect_to photos_path if current_user
    @dest = params[:dest]
  end
end
