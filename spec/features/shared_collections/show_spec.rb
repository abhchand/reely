require "rails_helper"

RSpec.feature "share collections show page", type: :feature do
  let(:user) { create(:user) }
  let!(:collection) { create_collection_with_photos(owner: user) }

  it "user can visit a shared collection show page" do
    log_in(user)

    visit shared_collection_path(id: collection.share_id)
    expect_show_page_for(collection)
  end

  context "user is not logged in" do
    it "user can still access the shared collection show page" do
      visit shared_collection_path(id: collection.share_id)
      expect_show_page_for(collection)
    end
  end

  def expect_show_page_for(collection)
    expect(page).to_not have_selector(".responsive-navigation-view-container")
    expect(page).
      to have_selector(".shared-collections-show__photo-grid-container")
    expect(page.all(".photo-grid__photo-container").count).
      to eq(collection.photos.count)
  end
end