require "rails_helper"

RSpec.feature "Confirming Email", type: :feature do
  # rubocop:disable LineLength
  #
  # Explanation of confirmation routes behavior
  #
  # The `new` path is used to send (re-send) confirmation instructions
  # The `create` path is used to create a token and send email, as called  by the `new` page
  # The `show` path is meant to be used with a `?confirmation_token=...` param.
  #
  #   - If token is valid it redirects to root_path
  #   - If token is invalid it renders the same view as `:new` to resend confirmation
  #     It still keeps the same route though.
  #
  #    new_user_confirmation GET    /users/confirmation/new  ->  devise/confirmations#new
  #        user_confirmation GET    /users/confirmation      ->  devise/confirmations#show
  #                          POST   /users/confirmation      ->  devise/confirmations#create
  #
  # rubocop:enable LineLength

  let(:user_attrs) do
    {
      first_name: "Asha",
      last_name: "Bhosle",
      email: "asha@singers.com",
      password: "Best!s0ngz"
    }
  end

  let(:user) { User.last }

  before do
    register(user_attrs)
    clear_mailer_queue
  end

  it "user can confirm their email" do
    confirm(user)

    expect(page).to have_current_path(new_user_session_path)
    expect(page).
      to have_flash_message(t("devise.confirmations.confirmed")).
      of_type(:notice)

    expect(user.reload.confirmed?).to eq(true)
  end

  context "invalid token" do
    it "user sees an auth error" do
      confirm(user, token: "abcde")

      expect(page).
        to have_current_path(
          user_confirmation_path(confirmation_token: "abcde")
        )
      expect(page).
        to have_auth_error(validation_error_for(:confirmation_token, :invalid))

      expect(user.reload.confirmed?).to eq(false)
    end
  end

  context "expired token" do
    before { @grace_period = Devise.confirm_within }

    it "user sees an auth error" do
      raise "expected non-nil value!" unless @grace_period

      travel(@grace_period + 1.day) { confirm(user) }

      expect(page).
        to have_current_path(
          user_confirmation_path(confirmation_token: user.confirmation_token)
        )
      expect(page).
        to have_auth_error(
          t(
            "errors.messages.confirmation_period_expired",
            period: "3 days"
          )
        )

      expect(user.reload.confirmed?).to eq(false)
    end
  end

  context "email is already confirmed" do
    it "user sees a error message" do
      user.update!(confirmed_at: Time.zone.now)
      confirm(user)

      expect(page).
        to have_current_path(
          user_confirmation_path(confirmation_token: user.confirmation_token)
        )
      expect(page).to have_auth_error(t("errors.messages.already_confirmed"))

      expect(user.reload.confirmed?).to eq(true)
    end
  end

  context "email is pending reconfirmation" do
    let(:user) { create(:user, :pending_reconfirmation) }

    it "user can confirm their email" do
      # rubocop:disable LineLength
      expect do
        confirm(user)
      end.to(change { user.reload.pending_reconfirmation? }.from(true).to(false))
      # rubocop:enable LineLength

      expect(user.reload.confirmed?).to eq(true)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(t("devise.confirmations.confirmed")).
        of_type(:notice)
    end
  end

  context "omniauth account" do
    let(:user) { create(:user, :omniauth, provider: "google_oauth2") }

    # We skip the email confirmation process for omniauth logins since we
    # assume the third party service has already verified this.

    it "user sees auth error that confirmation token is blank" do
      expect(user.confirmation_token).to be_nil

      confirm(user)

      expect(page).
        to have_current_path(
          user_confirmation_path(confirmation_token: user.confirmation_token)
        )
      expect(page).
        to have_auth_error(validation_error_for(:confirmation_token, :blank))

      # We still consider the account confirmed because it's omniauth, even
      # though `confirmed_at` is `nil`
      expect(user.reload.confirmed?).to eq(true)
    end

    context "confirmation token exists" do
      # The User model validates that no confirmation attributes are set
      # for omniauth records, so this test scenario wouldn't realistically ever
      # occur.
      #
      # However, we still want to test it because -
      #   1. We want to document the behavior in specs
      #   2. If the validations are ever bypassed for any reason, we want to
      #      confirm behavior
      #

      before do
        user.update_column(:confirmed_at, nil)
        user.update_column(:confirmation_sent_at, 1.minute.ago)
        user.update_column(:confirmation_token, Devise.friendly_token)
      end

      it "user sees auth error that account is already confirmed" do
        confirm(user)

        expect(page).
          to have_current_path(
            user_confirmation_path(confirmation_token: user.confirmation_token)
          )
        expect(page).to have_auth_error(t("errors.messages.already_confirmed"))

        # We still consider the account confirmed because it's omniauth, even
        # though `confirmed_at` is `nil`
        expect(user.reload.confirmed?).to eq(true)
      end
    end
  end

  describe "resending confirmation email" do
    it "user can resend the confirmation email" do
      old_token = user.confirmation_token

      expect do
        resend_confirmation(user)
      end.to_not(change { user.reload.confirmed? })

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(t("devise.confirmations.send_instructions")).
        of_type(:notice)

      new_token = user.reload.confirmation_token
      expect(old_token).to eq(new_token)

      email = mailer_queue.first
      expect(mailer_queue.count).to eq(1)
      expect(email[:klass]).to eq(Devise::Mailer)
      expect(email[:method]).to eq(:confirmation_instructions)
      expect(email[:args][:record]).to eq(user)
      expect(email[:args][:token]).to eq(new_token)
      expect(email[:args][:opts]).to eq({})
    end

    it "shows error when the email is already confirmed" do
      confirm(user)
      expect(user.reload.confirmed?).to eq(true)

      resend_confirmation(user)

      expect(page).to have_current_path(user_confirmation_path)
      expect(page).to have_auth_error(t("errors.messages.already_confirmed"))

      expect(mailer_queue.count).to eq(0)
    end

    it "shows error when the email is invalid" do
      resend_confirmation(user, email: "abcde@foo.com")

      expect(page).to have_current_path(user_confirmation_path)
      expect(page).to have_auth_error(t("errors.messages.not_found"))

      expect(mailer_queue.count).to eq(0)
    end

    context "email is pending reconfirmation" do
      let(:user) { create(:user, :pending_reconfirmation) }

      it "user can resend the confirmation email to the pending email" do
        expect do
          resend_confirmation(user, email: user.unconfirmed_email)
        end.to_not(change { user.reload.pending_reconfirmation? })

        expect(page).to have_current_path(new_user_session_path)
        expect(page).
          to have_flash_message(t("devise.confirmations.send_instructions")).
          of_type(:notice)

        user.reload

        email = mailer_queue.first
        expect(mailer_queue.count).to eq(1)
        expect(email[:klass]).to eq(Devise::Mailer)
        expect(email[:method]).to eq(:confirmation_instructions)
        expect(email[:args][:record]).to eq(user)
        expect(email[:args][:token]).to eq(user.confirmation_token)
        expect(email[:args][:opts]).to eq(to: user.unconfirmed_email)
      end

      it "user can not resend the confirmation email to the original email" do
        resend_confirmation(user)

        email = mailer_queue.first
        expect(mailer_queue.count).to eq(1)
        expect(email[:klass]).to eq(Devise::Mailer)
        expect(email[:method]).to eq(:confirmation_instructions)
        expect(email[:args][:opts]).to eq(to: user.unconfirmed_email)
      end
    end

    context "omniauth account" do
      let(:user) { create(:user, :omniauth, provider: "google_oauth2") }

      # We skip the email confirmation process for omniauth logins since we
      # assume the third party service has already verified this.

      it "user sees auth error that account is already confirmed" do
        resend_confirmation(user)

        expect(page).to have_current_path(user_confirmation_path)
        expect(page).to have_auth_error(t("errors.messages.already_confirmed"))

        expect(mailer_queue.count).to eq(0)

        # We still consider the account confirmed because it's omniauth, even
        # though `confirmed_at` is `nil`
        expect(user.reload.confirmed?).to eq(true)
      end
    end
  end
end
