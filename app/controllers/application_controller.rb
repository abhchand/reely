class ApplicationController < ActionController::Base
  include ApplicationHelper
  include WebpackHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_if_deactivated
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

  def check_if_deactivated
    return unless user_signed_in? && current_user.deactivated?

    # Need to skip this action when logging out, otherwise it just redirects
    # back to the same page. Ideally we'd do this by inserting a
    # `skip_before_action` but this controller is implemented by Devise and
    # we'd have to set up a fully subclassed controller just to skip this.
    # This is a workaround but if we have more exceptions we should consider
    # implementing this the proper way.
    # rubocop:disable Metrics/LineLength
    return if params[:controller] == "devise/sessions" && params[:action] == "destroy"
    # rubocop:enable Metrics/LineLength

    respond_to do |format|
      format.json { render json: { error: "User is deactivated" }, status: 403 }
      format.html { redirect_to(deactivated_user_index_path) }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
