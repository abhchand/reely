require "rails_helper"

RSpec.feature "collections card", type: :feature do
  let(:user) { create(:user) }

  before { log_in(user) }

  it "user can open and close the menu", :js do
    collection1 = create_collection_with_photos(owner: user)
    collection2 = create_collection_with_photos(owner: user)

    visit collections_path
    visit current_path

    expect_menu_is_closed(collection1)
    expect_menu_is_closed(collection2)

    toggle_menu(collection1)

    expect_menu_is_open(collection1)
    expect_menu_is_closed(collection2)

    toggle_menu(collection2)

    expect_menu_is_open(collection1)
    expect_menu_is_open(collection2)

    toggle_menu(collection2)

    expect_menu_is_open(collection1)
    expect_menu_is_closed(collection2)

    toggle_menu(collection1)

    expect_menu_is_closed(collection1)
    expect_menu_is_closed(collection2)
  end

  def find_collection(collection)
    page.find(".collections-card[data-id='#{collection.synthetic_id}']")
  end

  def toggle_menu(collection)
    collection_el = find_collection(collection)
    collection_el.find(".collections-card__menu-toggle").click
  end

  def expect_menu_is_closed(collection)
    collection_el = find_collection(collection)
    expect(collection_el).
      to have_selector(".collections-card__menu", visible: false)

    toggle_menu_el = collection_el.find(".collections-card__menu-toggle")
    expect(toggle_menu_el).
      to have_selector(".show-when-menu-closed", visible: true)
    expect(toggle_menu_el).
      to have_selector(".show-when-menu-open", visible: false)
  end

  def expect_menu_is_open(collection)
    collection_el = find_collection(collection)
    expect(collection_el).
      to have_selector(".collections-card__menu", visible: true)

    toggle_menu_el = collection_el.find(".collections-card__menu-toggle")
    expect(toggle_menu_el).
      to have_selector(".show-when-menu-closed", visible: false)
    expect(toggle_menu_el).
      to have_selector(".show-when-menu-open", visible: true)
  end
end
