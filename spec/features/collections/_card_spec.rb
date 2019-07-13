require "rails_helper"

RSpec.feature "collections card", type: :feature do
  let(:user) { create(:user) }

  before { log_in(user) }

  it "user can open and close the menu", :js do
    collection1 = create_collection_with_photos(owner: user)
    collection2 = create_collection_with_photos(owner: user)

    visit collections_path

    # Menus are closed by default
    expect_menu_is_closed(collection1)
    expect_menu_is_closed(collection2)

    # Menu can be opened
    open_menu(collection1)
    expect_menu_is_open(collection1)
    expect_menu_is_closed(collection2)

    # Close menu by clicking somehwere outside the menu
    page.find(".page-heading").click
    expect_menu_is_closed(collection1)
    expect_menu_is_closed(collection2)

    # Open menu again
    open_menu(collection1)
    expect_menu_is_open(collection1)
    expect_menu_is_closed(collection2)

    # Close menu by pressing the "Escape" key
    find("body").base.send_keys(:escape)
    expect_menu_is_closed(collection1)
    expect_menu_is_closed(collection2)

    # Opening new menus should close existing open menus
    open_menu(collection1)
    open_menu(collection2)
    expect_menu_is_closed(collection1)
    expect_menu_is_open(collection2)
  end

  describe "deleting collection", :js do
    it "user can delete a collection" do
      collection1 = create_collection_with_photos(owner: user)
      collection2 = create_collection_with_photos(owner: user)

      visit collections_path

      open_menu(collection1)
      click_delete_menu_option(collection1)
      click_delete_modal_submit

      expect { collection1.reload }.
        to raise_error(ActiveRecord::RecordNotFound)
      expect { collection2.reload }.to_not raise_error

      expect { find_collection(collection1) }.
        to raise_error(Capybara::ElementNotFound)
      expect { find_collection(collection2) }.to_not raise_error
    end

    it "user can cancel the deletion" do
      collection1 = create_collection_with_photos(owner: user)
      collection2 = create_collection_with_photos(owner: user)

      visit collections_path

      open_menu(collection1)
      click_delete_menu_option(collection1)
      click_delete_modal_cancel

      expect { collection1.reload }.to_not raise_error
      expect { collection2.reload }.to_not raise_error

      expect { find_collection(collection1) }.to_not raise_error
      expect { find_collection(collection2) }.to_not raise_error
    end
  end

  describe "sharing collection", :js do
    it "user can open and close the share modal" do
      collection1 = create_collection_with_photos(owner: user)
      _collection2 = create_collection_with_photos(owner: user)

      visit collections_path

      open_menu(collection1)

      click_share_menu_option(collection1)
      expect(page).to have_selector(".collections-share-modal", visible: true)

      click_share_modal_close
      expect(page).to have_selector(".collections-share-modal", visible: false)
    end
  end

  def find_collection(collection)
    page.find(".collections-card[data-id='#{collection.synthetic_id}']")
  end

  def open_menu(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-btn").click
  end

  def click_delete_menu_option(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-item--delete").click
  end

  def click_delete_modal_submit
    within(".collections-delete-modal") do
      page.find(".modal-content__button--submit").click
      wait_for_ajax
    end
  end

  def click_delete_modal_cancel
    within(".collections-delete-modal") do
      page.find(".modal-content__button--cancel").click
    end
  end

  def click_share_menu_option(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-item--share").click
  end

  def click_share_modal_close
    within(".collections-share-modal") do
      page.find(".modal-content__button--close").click
    end
  end

  def expect_menu_is_closed(collection)
    expect(find_collection(collection)).
      to have_selector(".collections-card__menu", visible: false)
  end

  def expect_menu_is_open(collection)
    expect(find_collection(collection)).
      to have_selector(".collections-card__menu", visible: true)
  end
end
