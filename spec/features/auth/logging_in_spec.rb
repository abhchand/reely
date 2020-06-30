require "rails_helper"

RSpec.feature "Logging In", type: :feature do
  let(:user) { create(:user) }

  before { user }

  it "user can log in" do
    log_in(user)

    expect(page).to have_current_path(photos_path)
    expect(page).to_not have_flash_message
  end

  it "preserves the user's original destination" do
    visit collections_path

    expect(page).to have_current_path(new_user_session_path)

    # Failed Login Attempt

    log_in(user, email: "bad-email@ga.gov")
    expect(page).to have_current_path(new_user_session_path)

    # Successful Login Attempt

    log_in(user)
    expect(page).to have_current_path(collections_path)
  end

  context "first login" do
    let(:user_attrs) do
      {
        first_name: "Asha",
        last_name: "Bhosle",
        email: "asha@singers.com",
        password: "Best!s0ngz"
      }
    end

    context "a user invitation exists" do
      let!(:user_invitation) do
        create(:user_invitation, email: user_attrs[:email])
      end

      it "completes the user invitation" do
        register(user_attrs)

        user = User.last

        confirm(user)
        log_in(user, password: user_attrs[:password])

        expect(user_invitation.reload.invitee).to eq(user)
      end
    end
  end

  context "invalid email" do
    it "displays a flash error" do
      log_in(user, email: "bad-email@ga.gov")

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(
          t(
            "devise.failure.invalid",
            authentication_keys: User.human_attribute_name(:email)
          )
        ).of_type(:alert)
    end
  end

  context "invalid password" do
    it "displays a flash error" do
      log_in(user, password: "bad-password")

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(
          t(
            "devise.failure.invalid",
            authentication_keys: User.human_attribute_name(:email)
          )
        ).of_type(:alert)
    end
  end

  context "email is not confirmed" do
    let(:user) { create(:user, :unconfirmed) }

    it "displays a flash error" do
      log_in(user)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(t("devise.failure.unconfirmed")).of_type(:alert)
    end
  end

  context "email is pending reconfirmation" do
    let(:user) { create(:user, :pending_reconfirmation) }

    it "user can log in with the original email" do
      log_in(user)

      expect(page).to have_current_path(photos_path)
      expect(page).to_not have_flash_message
    end

    it "user can not log in with pending email" do
      log_in(user, email: user.unconfirmed_email)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).
        to have_flash_message(
          t(
            "devise.failure.invalid",
            authentication_keys: User.human_attribute_name(:email)
          )
        ).of_type(:alert)
    end
  end

  describe "tracking log ins" do
    let(:now) { Time.zone.now }

    it "updates tracking infomation" do
      travel_to(now) do
        expect do
          log_in(user)
        end.to(change { user.reload.sign_in_count }.by(1))
      end

      # 1. Timestamps seem to be stored as rounded to the nearest whole second
      # 2. "Last sign in" is updated to match "current sign in" info if blank

      expect(user.current_sign_in_at).to eq(now.change(usec: 0))
      expect(user.current_sign_in_ip.to_s).to eq("127.0.0.1")

      expect(user.last_sign_in_at).to eq(now.change(usec: 0))
      expect(user.last_sign_in_ip).to eq("127.0.0.1")
    end

    it "does not update tracking information while navigating the app" do
      travel_to(now) { log_in(user) }
      travel_to(now + 5.minutes) { visit current_path }

      user.reload

      expect(user.sign_in_count).to eq(1)

      expect(user.current_sign_in_at).to eq(now.change(usec: 0))
      expect(user.current_sign_in_ip.to_s).to eq("127.0.0.1")

      expect(user.last_sign_in_at).to eq(now.change(usec: 0))
      expect(user.last_sign_in_ip).to eq("127.0.0.1")
    end

    context "user has logged in before" do
      before do
        travel_to(now - 5.minutes) do
          log_in(user)
          log_out
        end
      end

      it "updates tracking infomation on subsequent log in" do
        travel_to(now) { log_in(user) }

        user.reload

        expect(user.sign_in_count).to eq(2)

        expect(user.current_sign_in_at).to eq(now.change(usec: 0))
        expect(user.current_sign_in_ip.to_s).to eq("127.0.0.1")

        expect(user.last_sign_in_at).to eq((now - 5.minutes).change(usec: 0))
        expect(user.last_sign_in_ip).to eq("127.0.0.1")
      end
    end
  end

  describe "session timeout" do
    let(:now) { Time.zone.now }
    let(:timeout) { Devise.timeout_in }

    before { expect(timeout).to_not be_nil }

    it "times out after a continuous period of inactivity" do
      travel_to(now) { log_in(user) }

      travel_to(now - 2.second) do
        visit photos_path
        expect(page).to have_current_path(photos_path)
      end

      travel_to(now - 1.second) do
        visit photos_path
        expect(page).to have_current_path(photos_path)
      end

      travel_to(now + timeout) do
        visit photos_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe "omniauth account" do
    let(:user) { create(:user, :omniauth, provider: "google_oauth2") }

    let(:auth_hash) do
      {
        uid: "some-fake-uid",
        info: {
          first_name: "Srinivasa",
          last_name: "Ramanujan",
          email: "srini@math.com",
          image: fixture_path_for("images/chennai.jpg")
        }
      }
    end

    before { user.update!(provider: "google_oauth2", uid: auth_hash[:uid]) }

    it "user can log in" do
      mock_google_oauth2_auth_response(auth_hash)
      original_attrs = user.attributes

      expect do
        log_in_with_omniauth("google_oauth2")
      end.to_not(change { User.count })

      expect(page).to have_current_path(photos_path)

      user = User.last
      expect(user.first_name).to eq(original_attrs["first_name"])
      expect(user.last_name).to eq(original_attrs["last_name"])
      expect(user.email).to eq(original_attrs["email"])
      expect(user.uid).to eq(original_attrs["uid"])
      expect(user.provider).to eq("google_oauth2")
      expect(user.avatar.attached?).to eq(false)
    end

    context "a user invitation exists" do
      it "completes the user invitation" do
        # See `signing_up_spec`
      end
    end

    context "email is pending reconfirmation" do
      let(:user) do
        create(
          :user,
          :omniauth,
          :pending_reconfirmation,
          provider: "google_oauth2"
        )
      end

      it "user can log in" do
        mock_google_oauth2_auth_response(auth_hash)
        expect do
          log_in_with_omniauth("google_oauth2")
        end.to_not(change { User.count })

        expect(page).to have_current_path(photos_path)
        expect(page).to_not have_flash_message
      end
    end

    context "omniauth results in a failure" do
      before { mock_google_oauth2_auth_error(:invalid_credentials) }

      it "redirects to the failure path" do
        expect do
          log_in_with_omniauth("google_oauth2")
        end.to_not(change { User.count })

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash_message(
          t("devise.omniauth_callbacks.failure", reason: "Invalid credentials")
        )
      end
    end

    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "user can still log in" do
        mock_google_oauth2_auth_response(auth_hash)

        expect do
          log_in_with_omniauth("google_oauth2")
        end.to_not(change { User.count })

        expect(page).to have_current_path(photos_path)
      end
    end

    it "preserves the user's original destination" do
      visit account_profile_index_path

      expect(page).to have_current_path(new_user_session_path)

      # Failed Login Attempt
      mock_google_oauth2_auth_error(:invalid_credentials)

      expect { log_in_with_omniauth("google_oauth2") }.
        to_not(change { User.count })
      expect(page).to have_current_path(new_user_session_path)

      # Successful Login Attempt

      mock_google_oauth2_auth_response(auth_hash)
      expect { log_in_with_omniauth("google_oauth2") }.
        to_not(change { User.count })
      expect(page).to have_current_path(account_profile_index_path)
    end

    describe "tracking log ins" do
      let(:now) { Time.zone.now }

      it "updates tracking infomation" do
        mock_google_oauth2_auth_response(auth_hash)

        travel_to(now) do
          expect do
            log_in_with_omniauth("google_oauth2")
          end.to(change { user.reload.sign_in_count }.by(1))
        end

        # 1. Timestamps seem to be stored as rounded to the nearest whole second
        # 2. "Last sign in" is updated to match "current sign in" info if blank

        expect(user.current_sign_in_at).to eq(now.change(usec: 0))
        expect(user.current_sign_in_ip.to_s).to eq("127.0.0.1")

        expect(user.last_sign_in_at).to eq(now.change(usec: 0))
        expect(user.last_sign_in_ip).to eq("127.0.0.1")
      end
    end
  end
end
