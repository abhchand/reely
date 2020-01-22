class Admin::UserRolesController < AdminController
  include UserHelper

  before_action :ensure_json_request, only: %i[update]
  before_action :user, only: %i[update]
  before_action :only_editable_users, only: %i[update]

  def update
    update_service = Admin::UserRoles::UpdateService.call(
      user: user,
      roles: update_params[:roles]
    )

    status, json =
      if update_service.success?
        [200, {}]
      else
        [update_service.status, { error: update_service.error }]
      end

    update_service.log.tap { |msg| Rails.logger.debug(msg) if msg }

    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end

  private

  def update_params
    params.permit(
      roles: []
    )
  end
end
