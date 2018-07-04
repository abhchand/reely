class AuthenticateUser
  include Interactor

  def call
    @params = context.params

    case
    when missing_email?    then handle_missing_email
    when missing_password? then handle_missing_password
    when invalid_login?    then handle_invalid_login
    end
  end

  private

  def i18n_scope
    "sessions.create.authenticate"
  end

  def missing_email?
    @params[:email].blank?
  end

  def handle_missing_email
    context.fail!(error_message: I18n.t(".blank_email", scope: i18n_scope))
  end

  def missing_password?
    @params[:password].blank?
  end

  def handle_missing_password
    context.fail!(error_message: I18n.t(".blank_password", scope: i18n_scope))
  end

  def invalid_login?
    context.user = User.find_by_email(@params[:email])
    context.user.blank? || !context.user.correct_password?(@params[:password])
  end

  def handle_invalid_login
    context.fail!(error_message: I18n.t(".invalid_login", scope: i18n_scope))
  end
end
