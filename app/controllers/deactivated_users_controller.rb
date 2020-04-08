class DeactivatedUsersController < ApplicationController
  include UserHelper

  skip_before_action :check_if_deactivated, only: %i[index]

  before_action :ensure_json_request, only: %i[destroy]
  before_action :user, only: %i[destroy]
  before_action :only_editable_users, only: %i[destroy]

  def index
    # In case someone visits this URL directly without truly
    # being deactivated :)
    redirect_to(root_path) unless current_user.deactivated?
  end

  # "destroying" a deactivated user amounts to reactivating the user (i.e.
  # eliminating the deactivated status). This endpoint would ideally be called
  # `activate` but going with `destroy` to keep the naming/action consistent
  # with the UsersController (e.g. "destroying" a user creates a deactivated
  # user)
  def destroy
    user.update!(deactivated_at: nil) if user.deactivated?

    respond_to do |format|
      format.json { render json: {}, status: 200 }
    end
  end
end
