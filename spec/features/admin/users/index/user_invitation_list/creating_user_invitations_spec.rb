require 'rails_helper'

RSpec.feature 'Creating User Invitations', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let(:inviter) { create(:user) }

  before { log_in(admin) }

  it 'admin can create a user invitation' do
    visit admin_users_path
    click_user_invitations_tab

    click_create_user_invitation_button

    # Ensure "Cancel" button works
    click_modal_close
    expect_modal_is_closed(async: true)
    expect_filter_table_records_to_be([])
    expect(UserInvitation.count).to eq(0)

    click_create_user_invitation_button

    # Ensure "Submit" button works
    fill_in('user_invitation[email]', with: 'foo@bar.com')
    expect do
      click_modal_submit
      expect_modal_is_closed(async: true)
      expect_filter_table_total_count_to_be(1)
    end.to change { UserInvitation.count }.by(1)

    user_invitation = UserInvitation.last
    expect(user_invitation.email).to eq('foo@bar.com')
    expect_filter_table_total_count_to_be(1)
    expect_filter_table_records_to_be([user_invitation])
  end

  context 'there is an error creating the User Invitation' do
    before { create(:user_invitation, email: 'foo@bar.com') }

    it 'admin can view error in modal' do
      visit admin_users_path
      click_user_invitations_tab

      click_create_user_invitation_button

      # Ensure error feedback works
      fill_in('user_invitation[email]', with: 'foo@bar.com')
      expect { click_modal_submit }.to_not(change { UserInvitation.count })
      expect(modal_error).to match(/already been invited/)
    end
  end
end
