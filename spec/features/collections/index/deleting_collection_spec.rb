require 'rails_helper'

RSpec.feature 'deleting collection', :js, type: :feature do
  let(:user) { create(:user) }

  before { log_in(user) }

  it 'user can delete a collection' do
    collection1 = create_collection_with_photos(owner: user)
    collection2 = create_collection_with_photos(owner: user)

    visit collections_path

    open_menu(collection1)
    click_delete_menu_option(collection1)

    old_count = Collection.count
    click_modal_submit
    wait_for { Collection.count == old_count - 1 }

    expect { collection1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect { collection2.reload }.to_not raise_error

    expect { find_collection(collection1) }.to raise_error(
      Capybara::ElementNotFound
    )
    expect { find_collection(collection2) }.to_not raise_error
  end

  it 'user can cancel the deletion' do
    collection1 = create_collection_with_photos(owner: user)
    collection2 = create_collection_with_photos(owner: user)

    visit collections_path

    open_menu(collection1)
    click_delete_menu_option(collection1)
    click_modal_close

    expect { collection1.reload }.to_not raise_error
    expect { collection2.reload }.to_not raise_error

    expect { find_collection(collection1) }.to_not raise_error
    expect { find_collection(collection2) }.to_not raise_error
  end

  def find_collection(collection)
    page.find(".collections-card[data-id='#{collection.synthetic_id}']")
  end

  def open_menu(collection)
    collection_el = find_collection(collection)
    collection_el.find('.collections-card__menu-btn').click
  end

  def click_delete_menu_option(collection)
    collection_el = find_collection(collection)
    collection_el.find('.collections-card__menu-item--delete').click
  end
end
