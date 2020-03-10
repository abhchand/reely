module UserInvitationHelper
  def user_invitation
    @user_invitation ||= begin
      UserInvitation.find_by_id(params[:id]).tap do |u|
        handle_user_invitation_not_found if u.blank?
      end
    end
  end

  def only_editable_user_invitations
    return if can?(:write, user_invitation)

    handle_insufficient_permissions
  end

  def ensure_can_manage_invitations
    return if can?(:write, :admin)

    handle_insufficient_permissions
  end

  def handle_user_invitation_not_found
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json do
        render json: { error: "User Invitation not found" }, status: 404
      end
    end
  end

  def handle_insufficient_permissions
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json do
        render json: { error: "Insufficent permissions" }, status: 403
      end
    end
  end
end
