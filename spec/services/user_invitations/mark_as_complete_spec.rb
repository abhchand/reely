require "rails_helper"

RSpec.describe UserInvitations::MarkAsComplete do
  let(:user) { create(:user) }
  let(:invitation) { create(:user_invitation, email: user.email) }

  it "updates the invitee on the UserInvitation record" do
    invitation

    expect do
      call
    end.to change { invitation.reload.invitee }.from(nil).to(user)
  end

  it "audits the change" do
    invitation

    expect { call }.to(change { Audited::Audit.count }.by(1))

    audit = Audited::Audit.last

    expect(audit.auditable).to eq(invitation)
    expect(audit.user).to eq(user)
    expect(audit.action).to eq("update")
    expect(audit.audited_changes).to eq("invitee_id" => [nil, user.id])
    expect(audit.version).to eq(2)
    expect(audit.request_uuid).to_not be_nil
    expect(audit.remote_address).to be_nil
  end

  it "calls UserInvitations::NotifyInviterOfCompletion" do
    invitation

    expect(UserInvitations::NotifyInviterOfCompletion).to receive(:call)
    call
  end

  context "no invitation exists" do
    it "does nothing" do
      user

      expect do
        call
      end.to_not(change { Audited::Audit.count })
    end

    it "does not call UserInvitations::NotifyInviterOfCompletion" do
      expect(UserInvitations::NotifyInviterOfCompletion).to_not receive(:call)
      call
    end
  end

  def call
    UserInvitations::MarkAsComplete.call(user)
  end
end
