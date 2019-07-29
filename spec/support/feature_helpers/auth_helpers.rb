module FeatureHelpers
  DEFAULT_PASSWORD = "default!Password123".freeze

  def log_in(user, opts = {})
    visit root_path

    within(".auth__form") do
      fill_in("user[email]", with: opts[:email] || user.email)
      fill_in("user[password]", with: parse_password(opts))
      click_button(t("users.sessions.new.form.submit"))
    end

    wait_for_ajax
  end

  def log_in_with_omniauth(provider)
    if OmniAuth.config.mock_auth[provider.to_sym].empty?
      raise("No OmniAuth response defined for provider '#{provider}'")
    end

    visit(send("user_#{provider}_omniauth_authorize_path"))
  end

  def log_out
    visit destroy_user_session_path
  end

  def register(opts = {})
    visit new_user_registration_path

    within(".auth__form") do
      fill_in("user[first_name]", with: opts[:first_name])
      fill_in("user[last_name]", with: opts[:last_name])
      fill_in("user[email]", with: opts[:email])
      fill_in("user[password]", with: parse_password(opts))
      fill_in("user[password_confirmation]", with: parse_confirmation(opts))

      click_button(t("users.registrations.new.form.submit"))
    end

    wait_for_ajax
  end

  def resend_confirmation(user, opts = {})
    visit new_user_confirmation_path

    within(".auth__form") do
      fill_in("user[email]", with: opts[:email] || user.email)

      click_button(t("users.confirmations.new.form.submit"))
      wait_for_ajax
    end
  end

  def confirm(user, opts = {})
    token = opts[:token] || user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
  end

  def request_password_reset(user, opts = {})
    visit new_user_password_path

    within(".auth__form") do
      fill_in("user[email]", with: opts[:email] || user.email)
      click_button(t("users.passwords.new.form.submit"))
    end
  end

  def submit_password_reset(opts = {})
    visit edit_user_password_path(reset_password_token: opts.fetch(:token))

    within(".auth__form") do
      fill_in("user[password]", with: parse_password(opts))
      fill_in("user[password_confirmation]", with: parse_confirmation(opts))
      click_button(t("users.passwords.edit.form.submit"))
    end
  end

  def parse_password(opts)
    opts.key?(:password) ? opts[:password] : DEFAULT_PASSWORD
  end

  def parse_confirmation(opts)
    if opts.key?(:password_confirmation)
      opts[:password_confirmation]
    else
      opts[:password]
    end
  end
end
