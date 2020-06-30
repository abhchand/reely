class Devise::Custom::PasswordsController < Devise::PasswordsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled
end
