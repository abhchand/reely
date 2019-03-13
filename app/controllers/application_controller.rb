class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :ensure_authentication
  before_action :append_view_paths

  helper_method :view_context

  private

  def ensure_authentication
    return unless current_user.nil?

    requested_path = URI.parse(request.original_fullpath).path
    redirect_to root_path(dest: ERB::Util.url_encode(requested_path))
  end

  def ensure_xhr_only
    return if (defined? request) && request.xhr?
    redirect_to(root_path)
  end

  def append_view_paths
    append_view_path "app/views/application"
  end
end
