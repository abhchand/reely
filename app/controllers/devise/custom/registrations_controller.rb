class Devise::Custom::RegistrationsController < Devise::RegistrationsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled

  # Devise generates a route to edit registrations, but we'd rather
  # rather handle editing user/registration information through our
  # internal account profile page, so just blindly redirect there
  def edit
    redirect_to account_profile_index_path
  end
end
