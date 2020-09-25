class UserInvitationMailerPreview < ActionMailer::Preview
  def invite
    user_invitation = UserInvitation.last
    raise 'No UserInvitation found' if user_invitation.blank?

    UserInvitationMailer.invite(user_invitation.id)
  end

  def notify_inviter_of_completion
    user_invitation = UserInvitation.completed.last
    raise 'No completed UserInvitation found' if user_invitation.blank?

    UserInvitationMailer.notify_inviter_of_completion(user_invitation.id)
  end
end
