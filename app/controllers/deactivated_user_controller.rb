class DeactivatedUserController < ApplicationController
  skip_before_action :check_if_deactivated

  def index
    # In case someone visits this URL directly without truly
    # being deactivated :)
    redirect_to(root_path) unless current_user.deactivated?
  end
end
