require 'rails_helper'

RSpec.describe Admin::Audit::UserInvitationDescriptionService do
  let(:user_invitation) { create(:user_invitation) }

  before { @i18n_prefix = 'admin.audit.user_invitation_description' }

  context 'user invitation created' do
    before { user_invitation }

    it 'returns the correct description' do
      expect(call).to eq(
        t("#{@i18n_prefix}.created", email: user_invitation.email)
      )
    end
  end

  context 'user invitation destroyed' do
    before { user_invitation.destroy! }

    it 'returns the correct description' do
      expect(call).to eq(
        t("#{@i18n_prefix}.destroyed", email: user_invitation.email)
      )
    end
  end

  def call(audit = nil)
    Admin::Audit::UserInvitationDescriptionService.call(
      audit || Audited::Audit.last
    )
  end
end
