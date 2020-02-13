require "rails_helper"

RSpec.feature "share collections show page", type: :feature do
  let(:user) { create(:user) }
  let!(:collection) { create_collection_with_photos(owner: user) }

  it "user can visit a shared collection show page" do
    log_in(user)

    visit collections_sharing_display_path(id: collection.share_id)
    expect_show_page_for(collection)
  end

  context "user is not logged in" do
    it "user can still access the shared collection show page" do
      visit collections_sharing_display_path(id: collection.share_id)
      expect_show_page_for(collection)
    end
  end

  it "user can not add to a collection", :js do
    visit collections_sharing_display_path(id: collection.share_id)

    enable_selection_mode

    expect_add_to_collections_icon_to_not_be_visible
    click_photo(collection.photos[0])
    expect_add_to_collections_icon_to_not_be_visible
  end

  def expect_show_page_for(collection)
    expected_path = collections_sharing_display_path(id: collection.share_id)
    expect(page).to have_current_path(expected_path)

    expect(page).to_not have_selector(".responsive-navigation-view-container")
    expect(page).
      to have_selector(
        ".collections-sharing-display-show__photo-manager-container"
      )
    expect(page).to have_react_component("photo-manager").
      including_props(
        "permissions" => {
          "allowAddingToCollection" => false,
          "allowRemovingFromCollection" => false,
          "isEditable" => false
        }
      )
  end
end
