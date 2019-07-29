OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.before(:each) do
    # Clear cached auth hashes
    User::OMNIAUTH_PROVIDERS.each do |provider|
      OmniAuth.config.mock_auth[provider.to_sym] = nil
    end
  end
end

User::OMNIAUTH_PROVIDERS.each do |provider|
  define_method "mock_#{provider}_auth_response" do |auth_hash|
    auth_hash = OmniAuth::AuthHash.new(auth_hash.dup) if auth_hash.is_a?(Hash)
    OmniAuth.config.mock_auth[provider.to_sym] = auth_hash
  end

  define_method "mock_#{provider}_auth_error" do |msg|
    OmniAuth.config.mock_auth[provider.to_sym] = msg.to_sym
  end
end
