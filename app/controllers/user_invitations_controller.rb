class UserInvitationsController < ApplicationController
  include UserInvitationHelper

  before_action :ensure_json_request, only: %i[destroy]
  before_action :user_invitation, only: %i[destroy]
  before_action :only_editable_user_invitations, only: %i[destroy]

  def destroy
    user_invitation.destroy!

    respond_to do |format|
      format.json { render json: {}, status: 200 }
    end
  end
end
