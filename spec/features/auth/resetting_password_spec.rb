require "rails_helper"

RSpec.feature "Resetting Password", type: :feature do
  # rubocop:disable Metrics/LineLength
  #
  # Explanation of password paths routes behavior
  #
  # Notes:
  #   - The `new` action represents the request form for a new password, which
  #     calls `create` and sends a reset password email
  #   - The `edit` action represents the new password submission form linked
  #     from the email, which calls `update` and updates the password.
  #
  #   - When the `create` or `update` actions error, they renders the `:new`
  #     template but through the same URL, so it renders as
  #     `/users/registrations`, without the `/new` suffix
  #
  #           new_user_password GET    /users/password/new            -> devise/passwords#new
  #          edit_user_password GET    /users/password/edit           -> devise/passwords#edit
  #               user_password PATCH  /users/password                -> devise/passwords#update
  #                             PUT    /users/password                -> devise/passwords#update
  #                             POST   /users/password                -> devise/passwords#create
  #
  # rubocop:enable Metrics/LineLength

  let(:user) { create(:user) }

  describe "requesting password reset" do
    shared_examples "user can request password reset" do
      it "user can request a password reset" do
        user
        now = Time.zone.now.change(nsec: 0)

        travel_to(now) do
          expect do
            request_password_reset(user)
          end.to(change { mailer_queue.size }.by(1))
        end

        user.reload

        expect(user.reset_password_token).to_not be_nil
        expect(user.reset_password_sent_at).to eq(now)

        email = mailer_queue.last
        expect(email[:klass]).to eq(Devise::Mailer)
        expect(email[:method]).to eq(:reset_password_instructions)
        expect(email[:args][:record]).to eq(user)
        expect(
          decode_db_token_from_url_token(email[:args][:token])
        ).to eq(user.reset_password_token)
        expect(email[:args][:opts]).to eq({})
      end
    end

    it_behaves_like "user can request password reset"

    context "email does not exist" do
      it "displays an auth form error" do
        expect do
          request_password_reset(user, email: "some-fake-email@example.com")
        end.to_not(change { mailer_queue.size })

        expect(page).to have_current_path(user_password_path)
        expect(page).
          to have_auth_error(validation_error_for(:email, :not_found))
      end
    end

    context "user email is unconfirmed" do
      let(:user) { create(:user, :unconfirmed) }

      it_behaves_like "user can request password reset"
    end

    context "user has pending email change" do
      let(:user) { create(:user, :pending_reconfirmation) }

      it_behaves_like "user can request password reset"
    end

    context "omniauth account" do
      let(:user) { create(:user, :omniauth, provider: "google_oauth2") }

      it "displays an auth form error notifying user of invalid action" do
        expect do
          request_password_reset(user)
        end.to_not(change { mailer_queue.size })

        provider = User.human_attribute_name("omniauth_provider.google_oauth2")
        error = validation_error_for(
          :base,
          :omniauth_not_recoverable,
          provider: provider
        )

        expect(page).to have_current_path(user_password_path)
        expect(page).to have_auth_error(error)
      end
    end
  end

  describe "reset password link" do
    before do
      request_password_reset(user)
      @token = (mailer_queue.last || {}).dig(:args, :token)
    end

    shared_examples "user can reset password with the link" do
      it "user can reset password with the link" do
        submit_password_reset(token: @token, password: "new!Password123")

        user.reload

        expect(user.valid_password?("new!Password123")).to eq(true)
        expect(user.reset_password_token).to be_nil
        expect(user.reset_password_sent_at).to be_nil

        expect(page).to have_current_path(new_user_session_path)
      end
    end

    it_behaves_like "user can reset password with the link"

    it "user can continue to sign in with the existing password" do
      log_in(user)

      user.reload

      expect(user.reset_password_token).to_not be_nil
      expect(user.reset_password_sent_at).to_not be_nil

      expect(page).to have_current_path(photos_path)
    end

    it "user can not re-use the same link after it has been used once" do
      submit_password_reset(token: @token, password: "new!Password123")
      submit_password_reset(token: @token, password: "newer!Password123")

      expect(page).to have_current_path(user_password_path)
      expect(page).
        to have_auth_error(
          validation_error_for(:reset_password_token, :invalid)
        )
    end

    context "token has expired" do
      before do
        expect(Devise.reset_password_within).to_not be_nil

        @now = user.reload.reset_password_sent_at +
          Devise.reset_password_within +
          1.minute
      end

      it "displays an auth error on form submit" do
        travel_to(@now) do
          submit_password_reset(
            token: @token,
            password: "new!Password123"
          )
        end

        expect(page).to have_current_path(user_password_path)
        expect(page).
          to have_auth_error(
            validation_error_for(:reset_password_token, :expired)
          )
      end
    end

    context "token is invalid" do
      before { @token = "abcdefgh" }

      it "displays an auth error on form submit" do
        submit_password_reset(token: @token, password: "new!Password123")

        expect(page).to have_current_path(user_password_path)
        expect(page).
          to have_auth_error(
            validation_error_for(:reset_password_token, :invalid)
          )
      end
    end

    context "token is blank" do
      before { @token = nil }

      it "redirects to the log in page with a flash error" do
        visit edit_user_password_path(reset_password_token: @token)

        expect(page).to have_current_path(new_user_session_path)
        expect(page).
          to have_flash_message(t("devise.passwords.no_token")).of_type(:alert)
      end
    end

    context "form submission error" do
      it "displays an auth error when password is blank" do
        submit_password_reset(
          token: @token,
          password: nil,
          password_confirmation: "new!Password123"
        )

        expect(page).to have_auth_error(validation_error_for(:password, :blank))
      end

      it "displays an auth error when password confirmation is blank" do
        submit_password_reset(
          token: @token,
          password: "new!Password123",
          password_confirmation: nil
        )

        expect(page).
          to have_auth_error(
            validation_error_for(:password_confirmation, :confirmation)
          )
      end

      it "displays an auth error when password and confirmation don't match" do
        submit_password_reset(
          token: @token,
          password: "new!Password123",
          password_confirmation: "other!Password123"
        )

        expect(page).
          to have_auth_error(
            validation_error_for(:password_confirmation, :confirmation)
          )
      end
    end

    context "user email is unconfirmed" do
      let(:user) { create(:user, :unconfirmed) }

      it_behaves_like "user can reset password with the link"
    end

    context "user has pending email change" do
      let(:user) { create(:user, :pending_reconfirmation) }

      it_behaves_like "user can reset password with the link"
    end

    context "omniauth account" do
      let(:user) { create(:user, :omniauth, provider: "google_oauth2") }

      it "user sees flash message that password reset token is blank" do
        expect(user.reset_password_token).to be_nil

        visit edit_user_password_path(reset_password_token: @token)

        expect(page).to have_current_path(new_user_session_path)
        expect(page).
          to have_flash_message(t("devise.passwords.no_token")).of_type(:alert)
      end

      context "reset password token exists" do
        # The User model validates that no reset password attributes are set
        # for omniauth records, and also disallows sending any reset password
        # emails.
        #
        # However if (somehow) a reset password link were generated, there's
        # no easy way to override Devise for omniauth accounts and display
        # a custom error.
        #
        # We leave the ugly error in place because this test scenario wouldn't
        # realistically ever occur.

        before do
          # Also resets `reset_password_sent_at`
          @token = user.send(:set_reset_password_token)
        end

        it "user sees auth error that various model fields are not blank" do
          submit_password_reset(
            token: @token,
            password: "new!Password123"
          )

          expect(page).to have_current_path(user_password_path)
          expect(user.reload.encrypted_password).to be_nil

          expect(page).to have_auth_error("must be blank")
        end
      end
    end
  end

  def decode_db_token_from_url_token(url_token)
    Devise.token_generator.digest(user, :reset_password_token, url_token)
  end
end
