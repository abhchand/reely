class UsersController < ApplicationController
  include UserHelper

  before_action :ensure_json_request, only: %i[destroy]
  before_action :user, only: %i[destroy]
  before_action :only_editable_users, only: %i[destroy]

  # No action points here, this is just for clarity / documentation. If you're
  # here looking for how users are created, it's handled as follows:
  #
  # * Native - Devise handles creating users via the `Registrations#create`
  #   method
  # * OmniAuth - Devise sets the omniauth to call back to the appropriate
  #   `Devise::CallbackController` action which handles creation.
  #
  # def create
  # end

  def destroy
    # Remove all roles
    user.roles.pluck(:name).each { |role| user.remove_role(role) }

    # Soft deletion
    user.update!(deactivated_at: Time.zone.now) unless user.deactivated?

    respond_to do |format|
      format.json { render json: {}, status: 200 }
    end
  end
end
