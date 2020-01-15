require "rails_helper"

RSpec.feature "Deactivated User", type: :feature do
  let(:user) { create(:user) }

  context "user is deactivated" do
    let(:user) { create(:user, :deactivated) }

    it "user can log in and is redirected to the deactivated user page" do
      log_in(user)

      expect(page).to have_current_path(deactivated_user_index_path)

      visit collections_path
      expect(page).to have_current_path(deactivated_user_index_path)
    end

    it "user can log out using the provided link" do
      log_in(user)

      page.find(".deactivated-user-index .log-out a").click
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "user is not deactivated" do
    it "user can not access the deactivated user page" do
      log_in(user)

      expect(page).to have_current_path(photos_path)

      # First visit another random path so we can confirm that the path
      # changes TO photos_path (target of root_path redirect)
      visit collections_path

      visit deactivated_user_index_path
      expect(page).to have_current_path(photos_path)
    end
  end
end
