require 'rails_helper'

RSpec.feature 'Deleting User Invitations', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let(:inviter) { create(:user) }

  let!(:invitations) do
    [
      create(
        # rubocop:disable Metrics/LineLength
        :user_invitation,
        email: 'user-twelve@test.com', inviter: inviter
      ),
      create(
        :user_invitation,
        email: 'user-thirteen@test.com', inviter: inviter
      ),
      create(
        :user_invitation,
        email: 'user-fourteen@test.com', inviter: inviter
      )
    ]
    # rubocop:enable Metrics/LineLength
  end

  before { log_in(admin) }

  it 'admin can delete a user invitation' do
    visit admin_users_path
    click_user_invitations_tab

    expect_filter_table_total_count_to_be(3)
    expect_filter_table_records_to_be(
      [invitations[2], invitations[1], invitations[0]]
    )

    click_filter_table_delete_for(invitations[2])

    # Ensure "Cancel" button works
    click_modal_close
    expect_modal_is_closed(async: true)
    expect_filter_table_records_to_be(
      [invitations[2], invitations[1], invitations[0]]
    )
    expect(UserInvitation.count).to eq(3)

    click_filter_table_delete_for(invitations[2])

    # Ensure "Submit" button works
    click_modal_submit
    expect_modal_is_closed(async: true)
    expect_filter_table_total_count_to_be(2)
    expect_filter_table_records_to_be([invitations[1], invitations[0]])
    expect { invitations[2].reload }.to raise_error(
      ActiveRecord::RecordNotFound
    )
  end

  describe 'Pagination' do
    before do
      # Add another invitation as invitations[3]. This makes the new ordered
      # list as
      #   -> invitations[3], invitations[2], invitations[1], invitations[0]
      # rubocop:disable Metrics/LineLength
      invitations <<
        create(
          :user_invitation,
          email: 'user-fifteen@test.com', inviter: inviter
        )
      # rubocop:enable Metrics/LineLength

      # Paginate 4 invitations across 2 pages
      stub_const('Api::Response::PaginationLinksService::PAGE_SIZE', 2)
    end

    it 'handles deactivating a user from a paginated set' do
      visit admin_users_path
      click_user_invitations_tab

      # Navigate to page 2 of 2
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[1], invitations[0]])

      # Delete invitations[0], the last invitation on this page
      click_filter_table_delete_for(invitations[0])
      click_modal_submit
      expect_modal_is_closed(async: true)

      # Check that we are taken back to the fist page and the invitation is
      # deleted
      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be([invitations[3], invitations[2]])
      expect { invitations[0].reload }.to raise_error(
        ActiveRecord::RecordNotFound
      )

      # Navigate to page 2 of 2
      click_filter_table_pagination_next
      expect_filter_table_records_to_be([invitations[1]])

      # Delete invitations[1], the only invitation on this page
      click_filter_table_delete_for(invitations[1])
      click_modal_submit
      expect_modal_is_closed(async: true)

      # Check that we are taken back to the fist page and the invitation is
      # deleted
      expect_filter_table_total_count_to_be(2)
      expect_filter_table_records_to_be([invitations[3], invitations[2]])
      expect { invitations[1].reload }.to raise_error(
        ActiveRecord::RecordNotFound
      )
    end

    context 'Searching' do
      it 'handles deleting an invitation from a paginated search result set' do
        visit admin_users_path
        click_user_invitations_tab

        # Search for "teen". This makes the new filtered ordered list as
        #   -> invitations[3], invitations[2], invitations[1]
        search_filter_table_for('teen')

        # Navigate to page 2 of 2
        click_filter_table_pagination_next
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([invitations[1]])

        # Delete invitations[1], the only invitation on this page
        click_filter_table_delete_for(invitations[1])
        click_modal_submit
        expect_modal_is_closed(async: true)

        # Check that we are taken back to the fist page and the user is deleted
        # Note that the search should also be cleared, exposing all remaining 3
        # users.
        # This makes the new filtered ordered list as
        #   -> admin, invitations[3], invitations[2], invitations[0]
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([invitations[3], invitations[2]])
        expect { invitations[1].reload }.to raise_error(
          ActiveRecord::RecordNotFound
        )
      end
    end
  end
end
