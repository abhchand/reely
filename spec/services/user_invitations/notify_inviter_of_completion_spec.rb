require 'rails_helper'

RSpec.describe UserInvitations::NotifyInviterOfCompletion do
  let(:user) { create(:user) }
  let(:invitation) { create(:user_invitation, email: user.email) }

  it 'sends the UserInvitationMailer#notify_inviter_of_completion mailer' do
    invitation

    expect { call }.to(change { mailer_queue.count }.by(1))

    email = mailer_queue.last
    expect(email[:klass]).to eq(UserInvitationMailer)
    expect(email[:method]).to eq(:notify_inviter_of_completion)
    expect(email[:args][:user_invitation_id]).to eq(invitation.id)
  end

  context 'no invitation exists' do
    it 'does not sent the mailer' do
      user

      expect { call }.to_not(change { mailer_queue.count })
    end
  end

  def call
    UserInvitations::NotifyInviterOfCompletion.call(user)
  end
end
