class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :append_view_paths

  helper_method :view_context

  private

  def ensure_json_request
    return if (defined? request) && request.format.to_sym == :json
    redirect_to(root_path)
  end

  def append_view_paths
    append_view_path "app/views/application"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
