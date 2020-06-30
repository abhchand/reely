class Devise::Custom::ConfirmationsController < Devise::ConfirmationsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled
end
