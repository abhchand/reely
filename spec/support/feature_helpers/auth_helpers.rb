module FeatureHelpers
  DEFAULT_PASSWORD = "password".freeze

  def log_in(user, opts = {})
    visit root_path

    within(".site-index-auth-form__container") do
      fill_in "session[email]", with: user.email
      fill_in("session[password]", with: opts[:password] || DEFAULT_PASSWORD)
      click_button(t("site.index.form.submit"))
    end

    wait_for_ajax
  end
end
