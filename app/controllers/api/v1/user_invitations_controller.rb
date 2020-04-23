class Api::V1::UserInvitationsController < Api::BaseController
  def index
    authorize! :read, :user_invitations

    user_invitations = UserInvitation.pending.order("lower(email)")
    user_invitations = search(user_invitations)
    user_invitations = paginate(user_invitations)

    json = serialize(
      user_invitations,
      links: pagination_links(user_invitations)
    )

    render json: json, status: :ok
  end

  private

  def search(user_invitations)
    # FYI: Search logic will sanitize any input SQL in `params[:search]`
    UserInvitations::SearchService.perform(user_invitations, params[:search])
  end

  def serialize(user, opts = {})
    UserInvitationSerializer.new(
      user,
      { params: {} }.deep_merge(opts)
    ).serializable_hash
  end
end
