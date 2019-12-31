require "rails_helper"

RSpec.feature "Search and Paginate", type: :feature, js: true do
  let(:admin) { create(:user, :admin) }

  let!(:users) do
    [
      create(:user, name: "User Twelve", email: "12@test.com"),
      create(:user, name: "User Thirteen", email: "13@test.com"),
      create(:user, name: "User Fourteen", email: "14@test.com")
    ]
  end

  before { log_in(admin) }

  describe "Searching" do
    it "admin can search records" do
      visit admin_users_path

      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([admin, users[2], users[1], users[0]])

      search_filter_table_for("t")
      expect_filter_table_total_count_to_be(3)
      expect_filter_table_records_to_be([users[2], users[1], users[0]])

      search_filter_table_for("ee")
      expect_filter_table_total_count_to_be(2)
      expect_filter_table_records_to_be([users[2], users[1]])

      # Empty state
      search_filter_table_for("x")
      expect(page.find(".filter-table--empty-state")).
        to have_content(t("components.filter_table.table.empty_state"))
    end

    it "admin can search records using multiple tokens" do
      visit admin_users_path

      search_filter_table_for("t 14")
      expect_filter_table_total_count_to_be(1)
      expect_filter_table_records_to_be([users[2]])
    end

    it "admin can clear the search" do
      admin.update!(name: "Ab Cd")

      visit admin_users_path

      search_filter_table_for("t 14")

      # For some reason `fill_in(..., with: "")` wont work here
      # so settle for sending several backspaces in a row
      4.times { search_filter_table_for(:backspace) }
      expect(page.find(".filter-table__search-input").value).to eq("")

      expect_filter_table_total_count_to_be(4)
      expect_filter_table_records_to_be([admin, users[2], users[1], users[0]])
    end
  end

  describe "Pagination" do
    before do
      # Add another user as users[3]. This makes the new ordered list as
      #   -> admin, users[3], users[2], users[1], users[0]
      users << create(:user, name: "User Fifteen", email: "15@test.com")

      # Paginate 5 users across 3 pages
      stub_const("Users::SearchService::PAGE_SIZE", 2)
    end

    it "admin can paginate through records" do
      visit admin_users_path

      # Page 1 of 3
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([admin, users[3]])

      # Page 2 of 3
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([users[2], users[1]])

      # Page 3 of 3
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([users[0]])

      # Page 3 of 3 (Next button is disabled)
      click_filter_table_pagination_next
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([users[0]])

      # Page 2 of 3
      click_filter_table_pagination_prev
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([users[2], users[1]])

      # Page 1 of 3
      click_filter_table_pagination_prev
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([admin, users[3]])

      # Page 1 of 3 (Prev button is disabled)
      click_filter_table_pagination_prev
      expect_filter_table_total_count_to_be(5)
      expect_filter_table_records_to_be([admin, users[3]])
    end

    context "Searching" do
      it "admin can search paginated results" do
        visit admin_users_path

        # Search for "teen". This makes the new filtered ordered list as
        #   -> users[3], users[2], users[1]
        search_filter_table_for("teen")

        # Page 1 of 2
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([users[3], users[2]])

        # Page 2 of 2
        click_filter_table_pagination_next
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([users[1]])

        # Page 1 of 2
        click_filter_table_pagination_prev
        expect_filter_table_total_count_to_be(3)
        expect_filter_table_records_to_be([users[3], users[2]])

        # Go back to the 2nd page and search for something.
        # This makes the new filtered ordered list as
        #   -> users[3], users[2]
        # We then ensure that the pagination resets
        click_filter_table_pagination_next
        search_filter_table_for(" f")

        expect_filter_table_total_count_to_be(2)
        expect_filter_table_records_to_be([users[3], users[2]])
      end
    end
  end
end
