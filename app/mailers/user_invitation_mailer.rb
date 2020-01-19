class UserInvitationMailer < BaseSendgridMailer
  def invite(user_invitation_id)
    @user_invitation = UserInvitation.find(user_invitation_id)

    @recipient = @user_invitation.email
    @subject = t(".subject")
    @body = t(".body", inviter: @user_invitation.inviter.name)
    @url = new_user_registration_url

    send_mail
  end
end
