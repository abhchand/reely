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

  it "user can delete a collection", :js do
    collection1 = create_collection_with_photos(owner: user)
    collection2 = create_collection_with_photos(owner: user)

    visit collections_path

    open_menu(collection1)
    click_delete(collection1)
    wait_for_ajax

    expect(collection1.reload).
      to raise_error(ActiveRecord::RecordNotFound)
    expect(collection2.reload).
      to_not raise_error(ActiveRecord::RecordNotFound)

    expect(find_collection(collection1)).
      to raise_error(Capybara::ElementNotFound)
    expect(find_collection(collection2)).
      to_not raise_error(Capybara::ElementNotFound)
  end

  def find_collection(collection)
    page.find(".collections-card[data-id='#{collection.synthetic_id}']")
  end

  def open_menu(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-btn").click
  end

  def click_delete(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-item--delete").click
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
