require "rails_helper"

RSpec.feature "sharing collection", :js, type: :feature do
  include FeatureHelpers::ShareCollectionModalHelpers

  let(:user) { create(:user) }
  let!(:collection) { create_collection_with_photos(owner: user) }

  before { log_in(user) }

  describe "link sharing" do
    describe "toggling link sharing" do
      it "user can toggle link sharing" do
        visit collection_path(collection)

        click_share_menu

        expect_link_sharing_disabled_for(collection)

        click_toggle
        expect_link_sharing_enabled_for(collection)

        click_toggle
        expect_link_sharing_disabled_for(collection)
      end
    end
  end

  it "user can open and close the share modal" do
    visit collection_path(collection)

    click_share_menu
    expect_modal_is_open

    click_modal_close
    expect_modal_is_closed
  end

  def click_share_menu
    page.find(".collections-show__action-bar-item--share").click
    wait_for_ajax
    expect(page).to have_selector(".modal-content__heading")
  end
end
