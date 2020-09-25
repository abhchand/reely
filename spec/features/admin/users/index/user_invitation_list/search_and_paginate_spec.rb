require 'rails_helper'

RSpec.feature 'Search and Paginate', type: :feature, js: true do
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

  describe 'Searching' do
    it 'admin can search records' do
      visit admin_users_path
      click_user_invitations_tab

      # rubocop:disable Metrics/LineLength

      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be(
        [invitations[2], invitations[1], invitations[0]]
      )

      search_filter_table_for('t')
      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be(
        [invitations[2], invitations[1], invitations[0]]
      )

      search_filter_table_for('ee')
      expect_filter_table_total_count_to_be(2)
      expect_filter_table_records_to_be([invitations[2], invitations[1]])

      # rubocop:enable Metrics/LineLength

      # Empty state
      search_filter_table_for('x')
      expect(page.find('.filter-table--empty-state')).to have_content(
        t('components.filter_table.table.empty_state')
      )
    end

    it 'admin can search records using multiple tokens' do
      visit admin_users_path
      click_user_invitations_tab

      search_filter_table_for('t v')
      expect_filter_table_total_count_to_be(1)
      expect_filter_table_records_to_be([invitations[0]])
    end

    it 'admin can clear the search' do
      visit admin_users_path
      click_user_invitations_tab

      search_filter_table_for('t v')

      # For some reason `fill_in(..., with: "")` wont work here
      # so settle for sending several backspaces in a row
      3.times { search_filter_table_for(:backspace) }
      expect(page.find('.filter-table__search-input').value).to eq('')

      # rubocop:disable Metrics/LineLength

      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be(
        [invitations[2], invitations[1], invitations[0]]
      )

      # rubocop:enable Metrics/LineLength
    end
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

    it 'admin can paginate through records' do
      visit admin_users_path
      click_user_invitations_tab

      # Page 1 of 2
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[3], invitations[2]])

      # Page 2 of 2
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[1], invitations[0]])

      # Page 2 of 2 (Next button is disabled)
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[1], invitations[0]])

      # Page 1 of 2
      click_filter_table_pagination_prev
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[3], invitations[2]])

      # Page 1 of 2 (Prev button is disabled)
      click_filter_table_pagination_prev
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([invitations[3], invitations[2]])
    end

    context 'Searching' do
      it 'admin can search paginated results' do
        visit admin_users_path
        click_user_invitations_tab

        # Search for "teen". This makes the new filtered ordered list as
        #   -> invitations[3], invitations[2], invitations[1]
        search_filter_table_for('teen')

        # Page 1 of 2
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([invitations[3], invitations[2]])

        # Page 2 of 2
        click_filter_table_pagination_next
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([invitations[1]])

        # Page 1 of 2
        click_filter_table_pagination_prev
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([invitations[3], invitations[2]])

        # Go back to the 2nd page and search for something.
        # This makes the new filtered ordered list as
        #   -> invitations[3], invitations[2]
        # We then ensure that the pagination resets
        click_filter_table_pagination_next
        search_filter_table_for(' f')

        expect_filter_table_total_count_to_be(2)
        expect_filter_table_records_to_be([invitations[3], invitations[2]])
      end
    end
  end
end
