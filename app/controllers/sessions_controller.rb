class SessionsController < ApplicationController
  skip_before_action :ensure_authentication

  def create
    if authenticate_user.success?
      set_session(authenticate_user.user)
      redirect_to(new_session_destination)
    else
      flash[:error] = authenticate_user.error_message
      # Redirect back to previous URL
      redirect_to request.env["HTTP_REFERER"]
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def authenticate_user
    @authenticate_user ||= AuthenticateUser.call(params: create_params)
  end

  def create_params
    params.require(:session).permit(
      :email,
      :password
    )
  end

  def set_session(user) # rubocop:disable AccessorMethodName
    session[:user_id] = user.id
  end

  def new_session_destination
    params[:dest].present? ? CGI.unescape(params[:dest]) : photos_path
  end
end
