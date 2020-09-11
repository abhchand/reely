class ApplicationController < ActionController::Base
  include ApplicationHelper
  include WebpackHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_if_deactivated
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :append_view_paths
  before_action :initialize_packs_list
  before_action :set_default_pack

  helper_method :view_context

  private

  def ensure_json_request
    return if (defined?(request)) && request.format.to_sym == :json
    redirect_to(root_path)
  end

  def append_view_paths
    append_view_path 'app/views/application'
  end

  def initialize_packs_list
    @use_packs = []
  end

  def set_default_pack
    @use_packs << 'common'
  end

  def verifier
    @verifier ||=
      ActiveSupport::MessageVerifier.new(
        Rails.application.secrets[:secret_key_base]
      )
  end

  protected

  def check_if_deactivated
    return unless user_signed_in? && current_user.deactivated?

    respond_to do |format|
      format.json { render json: { error: 'User is deactivated' }, status: 403 }
      format.html { redirect_to(deactivated_users_path) }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
