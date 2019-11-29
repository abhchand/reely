require "rails_helper"

RSpec.feature "sharing collection", :js, type: :feature do
  include FeatureHelpers::ShareCollectionModalHelpers

  let(:user) { create(:user) }
  let!(:collection) { create_collection_with_photos(owner: user) }

  before { log_in(user) }

  describe "link sharing" do
    describe "toggling link sharing" do
      it "user can toggle link sharing" do
        visit collections_path

        open_menu(collection)
        click_share_menu_option(collection)

        expect_link_sharing_disabled_for(collection)

        click_toggle
        expect_link_sharing_enabled_for(collection)

        click_toggle
        expect_link_sharing_disabled_for(collection)
      end

      context "multiple collections exist" do
        let(:other_collection) { create_collection_with_photos(owner: user) }

        it "preserves state across multiple collections" do
          # Set `other_collection` to have link sharing enabled
          other_collection.sharing_config["link_sharing_enabled"] = true
          other_collection.save!

          visit collections_path

          # Collection
          # Change from disabled -> enabled

          open_menu(collection)
          click_share_menu_option(collection)

          expect_link_sharing_disabled_for(collection)
          click_toggle
          expect_link_sharing_enabled_for(collection)

          click_share_modal_close

          # Other Collection
          # Change from enabled -> disabled

          open_menu(other_collection)
          click_share_menu_option(other_collection)

          expect_link_sharing_enabled_for(other_collection)
          click_toggle
          expect_link_sharing_disabled_for(other_collection)

          click_share_modal_close

          # Collection
          # Should be unchanged

          open_menu(collection)
          click_share_menu_option(collection)

          expect_link_sharing_enabled_for(collection)
        end
      end
    end

    it "user can copy the link" do
      visit collections_path

      open_menu(collection)
      click_share_menu_option(collection)
      click_toggle

      # Click the copy button
      # Also immediately test for the Action Notification since that times
      # out and goes away.
      expect(page).to_not have_selector(".action-notifications .notification")
      page.find(".share-collection__link-sharing-copy").click
      expect(page).to have_selector(".action-notifications .notification")
      wait_for_ajax

      # There's no easy way to test the contents of the clip board, so instead
      # paste it into some field and test its value
      # See: https://stackoverflow.com/q/58034127/10252006

      log_out
      input = page.find("#user_email")
      fill_in("user[email]", with: "")
      input.base.send_keys([:control, "v"])

      # TODO: Test clipboard pasted value
      # expect(input.value).to eq(link_sharing_url_for(collection))
    end

    it "user can refresh the link" do
      visit collections_path

      open_menu(collection)
      click_share_menu_option(collection)
      click_toggle

      expect(displayed_sharing_url).to eq(link_sharing_url_for(collection))
      page.find(".share-collection__link-sharing-renew").click

      wait_for do
        displayed_sharing_url == link_sharing_url_for(collection.reload)
      end
    end
  end

  it "user can open and close the share modal" do
    visit collections_path

    open_menu(collection)

    click_share_menu_option(collection)
    expect(page).to have_selector(".collections-share-modal", visible: true)

    click_share_modal_close
    expect(page).to have_selector(".collections-share-modal", visible: false)
  end

  def find_collection(collection)
    page.find(".collections-card[data-id='#{collection.synthetic_id}']")
  end

  def open_menu(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-btn").click
  end

  def click_share_menu_option(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-item--share").click

    wait_for_ajax
    expect(page).to have_selector(".share-collection__heading")
  end
end
