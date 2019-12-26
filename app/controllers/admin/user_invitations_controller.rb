class Admin::UserInvitationsController < AdminController
  def index
    respond_to do |format|
      format.json { @user_invitations = search_service.perform }
      format.html {}
    end
  end

  private

  def search_params
    params.permit(
      :search,
      :page,
      :page_size
    )
  end

  def search_service
    @search_service ||= UserInvitations::SearchService.new(search_params)
  end
end
