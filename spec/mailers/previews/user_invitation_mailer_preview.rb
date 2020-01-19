class UserInvitationMailerPreview < ActionMailer::Preview
  def invite
    user_invitation = UserInvitation.last
    raise "No UserInvitation found" if user_invitation.blank?

    UserInvitationMailer.invite(user_invitation.id)
  end
end
