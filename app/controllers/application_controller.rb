class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :ensure_authentication
  before_action :append_view_paths

  private

  def ensure_authentication
    if current_user.nil?
      requested_path = URI.parse(request.original_fullpath).path
      redirect_to root_path(dest: ERB::Util.url_encode(requested_path))
    end
  end

  def append_view_paths
    append_view_path "app/views/application"
  end
end
