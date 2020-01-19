require "rails_helper"

RSpec.feature "Deactivating Users", type: :feature, js: true do
  let(:admin) { create(:user, :admin) }

  let!(:users) do
    [
      create(:user, name: "User Twelve", email: "12@test.com"),
      create(:user, name: "User Thirteen", email: "13@test.com"),
      create(:user, name: "User Fourteen", email: "14@test.com")
    ]
  end

  before { log_in(admin) }

  it "admin can deactivate a user" do
    visit admin_users_path

    expect_filter_table_total_count_to_be(4)
    expect_filter_table_records_to_be([admin, users[2], users[1], users[0]])

    click_filter_table_deactivate_for(users[2])

    # Ensure "Cancel" button works
    click_modal_close
    expect_modal_is_closed(async: true)
    expect_filter_table_records_to_be([admin, users[2], users[1], users[0]])
    expect(users[2].reload.deactivated?).to eq(false)

    click_filter_table_deactivate_for(users[2])

    # Ensure "Submit" button works
    click_modal_submit
    expect_modal_is_closed(async: true)
    expect_filter_table_total_count_to_be(3)
    expect_filter_table_records_to_be([admin, users[1], users[0]])
    expect(users[2].reload.deactivated?).to eq(true)
  end

  describe "Pagination" do
    before do
      # Add another user as users[3]. This makes the new ordered list as
      #   -> admin, users[3], users[2], users[1], users[0]
      users << create(:user, name: "User Fifteen", email: "15@test.com")

      # Paginate 5 users across 3 pages
      stub_const("Users::SearchService::PAGE_SIZE", 2)
    end

    it "handles deactivating a user from a paginated set" do
      visit admin_users_path

      # Navigate to page 3 of 3
      2.times { click_filter_table_pagination_next }
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([users[0]])

      # Delete users[0], the only user on this page
      click_filter_table_deactivate_for(users[0])
      click_modal_submit
      expect_modal_is_closed(async: true)

      # Check that we are taken back to the fist page and the user is deleted
      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([admin, users[3]])
      expect(users[0].reload.deactivated?).to eq(true)

      # Navigate to page 2 of 2
      click_filter_table_pagination_next
      expect_filter_table_records_to_be([users[2], users[1]])

      # Delete users[2], the first user on this page
      click_filter_table_deactivate_for(users[2])
      click_modal_submit
      expect_modal_is_closed(async: true)

      # Check that we are taken back to the fist page and the user is deleted
      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be([admin, users[3]])
      expect(users[2].reload.deactivated?).to eq(true)
    end

    context "Searching" do
      it "handles deactivating a user from a paginated search result set" do
        visit admin_users_path

        # Search for "teen". This makes the new filtered ordered list as
        #   -> users[3], users[2], users[1]
        search_filter_table_for("teen")

        # Navigate to page 2 of 2
        click_filter_table_pagination_next
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([users[1]])

        # Delete users[1], the only user on this page
        click_filter_table_deactivate_for(users[1])
        click_modal_submit
        expect_modal_is_closed(async: true)

        # Check that we are taken back to the fist page and the user is deleted
        # Note that the search should also be cleared, exposing all remaining 4
        # users.
        # This makes the new filtered ordered list as
        #   -> admin, users[3], users[2], users[0]
        expect_filter_table_total_count_to_be(4)
        expect_filter_table_records_to_be([admin, users[3]])
        expect(users[1].reload.deactivated?).to eq(true)
      end
    end
  end
end
