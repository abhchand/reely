class UserInvitationSerializer < ApplicationSerializer
  attributes :email

  attribute :invited_at do |user_invitation, _params|
    user_invitation.created_at
  end

  link :self do |user_invitation, _params|
    Rails.application.routes.url_helpers.api_v1_user_invitations_url(
      user_invitation
    )
  end
end
