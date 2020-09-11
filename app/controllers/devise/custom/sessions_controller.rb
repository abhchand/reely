class Devise::Custom::SessionsController < Devise::SessionsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled, only: %i[create]

  # Need to skip this action when logging out, otherwise it just redirects
  # back to the same deactivated page.
  skip_before_action :check_if_deactivated, only: %i[destroy]

  before_action { @use_packs << 'auth' }
end
