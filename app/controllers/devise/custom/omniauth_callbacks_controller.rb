# rubocop:disable Metrics/LineLength
class Devise::Custom::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # rubocop:enable Metrics/LineLength

  def google_oauth2
    Rails.logger.info("Google OAuth2 Omniauth for #{auth&.uid}")

    service = UserManagement::Omniauth::GoogleOauth2Service.call(auth: auth)
    service.log.tap { |msg| Rails.logger.debug(msg) if msg }

    if service.success?
      user = service.user
      after_registration(user)
      sign_in_and_redirect(user)
    else
      flash[:error] = service.error
      redirect_to(new_user_session_path)
    end
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def after_registration(new_user)
    UserInvitations::MarkAsComplete.call(new_user)
  end
end
