require 'rails_helper'

# rubocop:disable Metrics/LineLength
RSpec.describe UserManagement::Omniauth::GoogleOauth2Service,
               type: :interactor do
  # rubocop:enable Metrics/LineLength

  let(:auth) do
    OmniAuth::AuthHash.new(
      uid: 'some-fake-uid',
      info: {
        first_name: 'Srinivasa',
        last_name: 'Ramanujan',
        email: 'srini@math.com',
        image: fixture_path_for('images/chennai.jpg')
      }
    )
  end

  it 'creates a new user from the auth data' do
    result = nil
    expect { result = call }.to(change { User.count }.by(1))

    expect(result.success?).to eq(true)

    user = result.user
    expect(user.first_name).to eq(auth[:info][:first_name])
    expect(user.last_name).to eq(auth[:info][:last_name])
    expect(user.email).to eq(auth[:info][:email])
    expect(user.provider).to eq('google_oauth2')
    expect(user.uid).to_not eq(auth[:info][:uid])
    expect(user.avatar.attached?).to eq(true)

    expect(result.error).to be_nil
    expect(result.log).to be_nil
  end

  it 'audits the creation of the record' do
    result = call

    user = result.user
    audit = user.audits.last

    expect(audit.action).to eq('create')
    expect(audit.user).to be_nil
  end

  it "fails when the auth doens't exist" do
    result = nil
    expect { result = call(auth: nil) }.to_not(change { User.count })

    expect(result.success?).to eq(false)
    expect(result.user).to be_nil

    expect(result.error).to eq(I18n.t('generic_error'))
    expect(result.log).to match(/Missing auth/)
  end

  it "fails when uid doesn't exist" do
    auth[:uid] = nil

    result = nil
    expect { result = call }.to_not(change { User.count })

    expect(result.success?).to eq(false)
    expect(result.user).to be_nil

    expect(result.error).to eq(I18n.t('generic_error'))
    expect(result.log).to match(/Missing uid/)
  end

  context 'User record fails validation' do
    it 'fails with a generic error' do
      auth[:info][:email] = 'bad-email'

      result = nil
      expect { result = call }.to_not(change { User.count })

      expect(result.success?).to eq(false)
      expect(result.user).to be_nil

      expect(result.error).to eq(I18n.t('generic_error'))
      expect(result.log).to match(/User validation errors/)
    end

    context 'failed validation is for invalid domain' do
      before do
        stub_env('REGISTRATION_EMAIL_DOMAIN_WHITELIST' => 'example.com,x.yz')
      end

      it 'fails with the specific model error message' do
        auth[:info][:email] = 'bad-email@foo.gov'

        result = nil
        expect { result = call }.to_not(change { User.count })

        expect(result.success?).to eq(false)
        expect(result.user).to be_nil

        expect(result.error).to eq(
          validation_error_for(:email, :invalid_domain, domain: 'foo.gov')
        )
        expect(result.log).to match(/User validation errors/)
      end
    end
  end

  describe 'attaching avatar' do
    it 'succeeds when no avatar exists' do
      auth[:info][:image] = nil

      result = nil
      expect { result = call }.to(change { User.count }.by(1))

      expect(result.success?).to eq(true)
      user = result.user
      expect(user.avatar.attached?).to eq(false)

      expect(result.error).to be_nil
      expect(result.log).to be_nil
    end

    it 'succeeds even when avatar attachment fails' do
      auth[:info][:image] = fixture_path_for('images/does-not-exist.png')

      result = nil
      expect { result = call }.to(change { User.count }.by(1))

      expect(result.success?).to eq(true)
      user = result.user
      expect(user.avatar.attached?).to eq(false)

      expect(result.error).to be_nil
      expect(result.log).to match(/Failed avatar attachment/)
    end
  end

  context 'user already exists' do
    let(:existing) { create(:user, :omniauth, provider: 'google_oauth2') }

    before { auth[:uid] = existing.uid }

    it 'retrieves the existing user from the auth data' do
      result = nil
      expect { result = call }.to_not(change { User.count })

      expect(result.success?).to eq(true)

      user = result.user
      expect(user).to eq(existing)

      expect(result.error).to be_nil
      expect(result.log).to be_nil
    end

    it 'does not overwrite any existing attributes' do
      existing.avatar.attach(
        io: File.open(fixture_path_for('images/atlanta.jpg')),
        filename: 'atlanta.jpg'
      )
      expect(existing.avatar.attached?).to eq(true)

      attrs_before = attributes_for(existing)

      result = call

      user = result.user
      attrs_after = attributes_for(user)

      expect(attrs_after).to eq(attrs_before)
    end
  end

  def call(opts = {})
    UserManagement::Omniauth::GoogleOauth2Service.call(
      { auth: auth }.merge(opts)
    )
  end

  def attributes_for(user)
    {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      avatar_key: user.avatar.key
    }
  end
end
