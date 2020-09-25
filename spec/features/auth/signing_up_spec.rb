require 'rails_helper'

RSpec.feature 'Signing Up', type: :feature do
  # rubocop:disable Metrics/LineLength
  #
  # Explanation of registration (sign ups) routes behavior
  #
  # Notes:
  #   - The `edit` path is overridden and redirects to the signed in account
  #   - When the `create` action errors it renders the `:new` template but
  #     through the same URL, so it renders as `/users/registrations`, without
  #     the `/new` suffix
  #
  #       new_user_registration GET    /users/registrations/new       -> devise/registrations#new
  #
  #      edit_user_registration GET    /users/registrations/edit      -> devise/registrations#edit
  #     users_registration_edit GET    /users/registration/edit       -> redirect(301, /account/profile)
  #    cancel_user_registration GET    /users/registrations/cancel    -> devise/registrations#cancel
  #
  #           user_registration PATCH  /users/registrations           -> devise/registrations#update
  #                             PUT    /users/registrations           -> devise/registrations#update
  #                             DELETE /users/registrations           -> devise/registrations#destroy
  #                             POST   /users/registrations           -> devise/registrations#create
  # rubocop:enable Metrics/LineLength

  let(:user_attrs) do
    {
      first_name: 'Asha',
      last_name: 'Bhosle',
      email: 'asha@singers.com',
      password: 'b3sts0ngz#'
    }
  end

  it 'user can sign up and receive a confirmation email' do
    expect { register(user_attrs) }.to(change { User.count }.by(1))

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_flash_message(
      t('devise.registrations.signed_up_but_unconfirmed')
    ).of_type(:notice)

    user = User.last
    expect(user.confirmed?).to eq(false)
    expect(user.first_name).to eq(user_attrs[:first_name])
    expect(user.last_name).to eq(user_attrs[:last_name])
    expect(user.email).to eq(user_attrs[:email])
    expect(user.valid_password?(user_attrs[:password])).to eq(true)
    expect(user.confirmation_token).to_not be_nil

    email = mailer_queue.first
    expect(mailer_queue.count).to eq(1)
    expect(email[:klass]).to eq(Devise::Mailer)
    expect(email[:method]).to eq(:confirmation_instructions)
    expect(email[:args][:record]).to eq(user)
    expect(email[:args][:token]).to eq(user.confirmation_token)
    expect(email[:args][:opts]).to eq({})
  end

  describe 'form validation' do
    it 'displays an auth error when a field is blank' do
      user_attrs[:email] = ''

      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:email, :blank)
      expect(mailer_queue.count).to eq(0)
    end

    it "displays an auth error when passwords don't match" do
      user_attrs[:password_confirmation] = 'foo'

      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:password_confirmation, :confirmation)
      expect(mailer_queue.count).to eq(0)
    end

    it 'validates the password complexity' do
      user_attrs[:password] = 'sup'

      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:password, :invalid)
      expect(mailer_queue.count).to eq(0)
    end
  end

  context 'registration email domain whitelisting is enabled' do
    before do
      stub_env('REGISTRATION_EMAIL_DOMAIN_WHITELIST' => 'example.com,x.yz')
    end

    it 'allows registration when the domain is in the whitelist' do
      user_attrs[:email] = 'foo@x.yz'

      expect { register(user_attrs) }.to(change { User.count }.by(1))

      expect(page).to have_current_path(new_user_session_path)

      user = User.last
      expect(user.email).to eq(user_attrs[:email])
    end

    it 'disallows registration when the domain is not in the whitelist' do
      user_attrs[:email] = 'fake@bad-domain.gov'

      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:email, :invalid_domain, domain: 'bad-domain.gov')
    end
  end

  context 'an account with that email already exists' do
    let(:user) { create(:user) }

    before { user_attrs[:email] = user.email }

    shared_examples 'displays an auth error' do
      it 'displays an auth error' do
        user_attrs[:email] = user.email

        before_attrs = user.attributes
        clear_mailer_queue

        expect { register(user_attrs) }.to_not(change { User.count })

        expect_auth_error_for(:email, :taken)
        expect(user.reload.attributes).to eq(before_attrs)

        expect(mailer_queue.count).to eq(0)
      end
    end

    it_behaves_like 'displays an auth error'

    it 'is case and space insensitive' do
      user_attrs[:email] = " #{user.email.upcase} "
      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:email, :taken)
      expect(mailer_queue.count).to eq(0)
    end

    context 'account is unconfirmed' do
      let(:user) { create(:user, :unconfirmed) }

      it_behaves_like 'displays an auth error'
    end

    context 'account has pending email change' do
      let(:user) { create(:user, :pending_reconfirmation) }

      it_behaves_like 'displays an auth error'
    end
  end

  context 'a user invitation exists' do
    let!(:invitation) { create(:user_invitation, email: user_attrs[:email]) }

    it 'marks the user invitation as complete and notifies the inviter' do
      expect(invitation.invitee).to be_nil

      register(user_attrs)

      expect(invitation.reload.invitee.email).to eq(user_attrs[:email])

      email = mailer_queue.last
      expect(email[:klass]).to eq(UserInvitationMailer)
      expect(email[:method]).to eq(:notify_inviter_of_completion)
      expect(email[:args][:user_invitation_id]).to eq(invitation.id)
    end
  end

  describe 'accessing the edit registrations page' do
    let(:user) { create(:user) }

    it 'renders the 404 page' do
      visit '/users/registrations/edit'
    end
  end

  # "Signing up" with OmniAuth is a bit different because a successful sign
  # up / user creation automatically logs you in immediately after. Therefore
  # the specs below also test some aspects of logging in initially
  describe 'omniauth account' do
    let(:auth_hash) do
      {
        uid: 'some-fake-uid',
        info: {
          first_name: 'Srinivasa',
          last_name: 'Ramanujan',
          email: 'srini@math.com',
          image: fixture_path_for('images/chennai.jpg')
        }
      }
    end

    it 'user can log in and create an account' do
      mock_google_oauth2_auth_response(auth_hash)

      expect { log_in_with_omniauth('google_oauth2') }.to(
        change { User.count }.by(1)
      )

      expect(page).to have_current_path(photos_path)

      user = User.last
      expect(user.first_name).to eq(auth_hash[:info][:first_name])
      expect(user.last_name).to eq(auth_hash[:info][:last_name])
      expect(user.email).to eq(auth_hash[:info][:email])
      expect(user.uid).to eq(auth_hash[:uid])
      expect(user.provider).to eq('google_oauth2')
      expect(user.avatar.attached?).to eq(true)
    end

    it "preserves the user's original destination" do
      visit account_profile_index_path

      expect(page).to have_current_path(new_user_session_path)

      # Failed Login Attempt
      mock_google_oauth2_auth_error(:invalid_credentials)

      expect { log_in_with_omniauth('google_oauth2') }.to_not(
        change { User.count }
      )
      expect(page).to have_current_path(new_user_session_path)

      # Successful Login Attempt

      mock_google_oauth2_auth_response(auth_hash)
      expect { log_in_with_omniauth('google_oauth2') }.to(
        change { User.count }.by(1)
      )
      expect(page).to have_current_path(account_profile_index_path)
    end

    context 'a user invitation exists' do
      let!(:invitation) do
        create(:user_invitation, email: auth_hash[:info][:email])
      end

      it 'marks the user invitation as complete and notifies the inviter' do
        expect(invitation.invitee).to be_nil

        mock_google_oauth2_auth_response(auth_hash)
        log_in_with_omniauth('google_oauth2')

        expect(invitation.reload.invitee.email).to eq(auth_hash[:info][:email])

        email = mailer_queue.last
        expect(email[:klass]).to eq(UserInvitationMailer)
        expect(email[:method]).to eq(:notify_inviter_of_completion)
        expect(email[:args][:user_invitation_id]).to eq(invitation.id)
      end
    end

    context 'omniauth results in a failure' do
      before { mock_google_oauth2_auth_error(:invalid_credentials) }

      it 'redirects to the failure path' do
        expect { log_in_with_omniauth('google_oauth2') }.to_not(
          change { User.count }
        )

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash_message(
          t('devise.omniauth_callbacks.failure', reason: 'Invalid credentials')
        )
      end
    end

    context 'registration email domain whitelisting is enabled' do
      before do
        stub_env('REGISTRATION_EMAIL_DOMAIN_WHITELIST' => 'example.com,x.yz')
      end

      it 'allows registration when the domain is in the whitelist' do
        auth_hash[:info][:email] = 'foo@x.yz'
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to(
          change { User.count }.by(1)
        )

        expect(page).to have_current_path(photos_path)

        user = User.last
        expect(user.email).to eq(auth_hash[:info][:email])
      end

      it 'disallows registration when the domain is not in the whitelist' do
        auth_hash[:info][:email] = 'fake@bad-domain.gov'
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to_not(
          change { User.count }
        )

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash_message(
          validation_error_for(
            :email,
            :invalid_domain,
            domain: 'bad-domain.gov'
          )
        )
      end
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'user can still log in and create an account' do
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to(
          change { User.count }.by(1)
        )

        expect(page).to have_current_path(photos_path)
      end
    end

    describe 'tracking log ins' do
      let(:now) { Time.zone.now }

      it 'updates tracking infomation' do
        mock_google_oauth2_auth_response(auth_hash)

        travel_to(now) do
          expect { log_in_with_omniauth('google_oauth2') }.to(
            change { User.count }.by(1)
          )
        end

        user = User.last
        expect(user.reload.sign_in_count).to eq(1)

        # 1. Timestamps seem to be stored as rounded to the nearest whole second
        # 2. "Last sign in" is updated to match "current sign in" info if blank

        expect(user.current_sign_in_at).to eq(now.change(usec: 0))
        expect(user.current_sign_in_ip.to_s).to eq('127.0.0.1')

        expect(user.last_sign_in_at).to eq(now.change(usec: 0))
        expect(user.last_sign_in_ip).to eq('127.0.0.1')
      end
    end
  end

  def expect_auth_error_for(attribute, key, opts = {})
    expect(page).to have_current_path(user_registration_path)
    expect(page).to have_auth_error(validation_error_for(attribute, key, opts))
  end
end
