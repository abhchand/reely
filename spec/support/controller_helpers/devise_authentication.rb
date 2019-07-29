# Stubbing authentication for Devise, which uses Warden internally
# See: https://github.com/plataformatec/devise/wiki/How-To:-Stub-authentication-in-controller-specs

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

module ControllerHelpers
  def log_in(user = double("user"))
    if user.nil?
      allow(request.env["warden"]).to receive(:authenticate!).
        and_throw(:warden, scope: :user)
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
