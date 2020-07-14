class UserInvitations::NotifyInviterOfCompletion
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    invitation = UserInvitation.find_by_email(@user[:email].downcase)
    return if invitation.blank?

    UserInvitationMailer.delay.notify_inviter_of_completion(invitation.id)
  end
end
