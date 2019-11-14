module FeatureHelpers
  def find_photo_element(photo)
    find(".photo-grid-photo__container[data-id='#{photo.synthetic_id}']")
  end

  def click_photo(photo)
    find_photo_element(photo).click
  end

  def shift_click_photo(photo)
    find_photo_element(photo).click(:shift)
  end

  #
  # Control Panel
  #

  def expect_add_to_collections_icon_to_be_visible
    expect(page).to have_selector(".icon-tray__item--add-to-collection")
  end

  def expect_add_to_collections_icon_to_not_be_visible
    expect(page).to_not have_selector(".icon-tray__item--add-to-collection")
  end

  #
  # Add to Collection
  #

  # rubocop:disable Lint/UnusedMethodArgument
  def within_add_to_collection(&block)
    within(".icon-tray__item--add-to-collection") do
      yield
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def open_dropdown_menu
    find(".react-select-or-create .open-menu-btn").click
  end

  def find_option_for(collection)
    id = collection.synthetic_id
    # The <div> has the click event
    find(".react-select-or-create .select-items li[data-id='#{id}'] div")
  end

  def expect_option_for(collection)
    id = collection.synthetic_id
    expect(page).to have_selector(
      ".react-select-or-create .select-items li[data-id='#{id}']"
    )
  end

  def create_collection_button
    find(".react-select-or-create .create-item")
  end

  #
  # Photo Carousel
  #

  def click_photo_carousel_next
    find(".photo-carousel__navigation-container.next").click
  end

  def click_photo_carousel_prev
    find(".photo-carousel__navigation-container.prev").click
  end

  def close_photo_carousel
    find(".photo-carousel__close").click
  end

  def expect_photo_carousel_to_display(photo)
    photo = PhotoPresenter.new(photo, view: view_context)
    photo_el = find(".photo-carousel__current-photo-container")

    expect(photo_el["data-id"]).to eq(photo.synthetic_id)
    expect(photo_el.find("img")["src"]).
      to eq(prepend_host_to_path(photo.source_file_path))
  end

  def expect_photo_carousel_is_closed
    expect(page).to_not have_selector(".photo-carousel")
  end

  #
  # Photo Selection
  #

  def enable_selection_mode
    find(".icon-tray__item--open-control-panel").click
    photo_manager_el = page.find(".photo-manager")
    expect(photo_manager_el["class"]).
      to match(/photo-grid--selection-mode-enabled/)
  end

  def disable_selection_mode
    find(".icon-tray__item--close-control-panel").click
    photo_manager_el = page.find(".photo-manager")
    expect(photo_manager_el["class"]).
      to_not match(/photo-grid--selection-mode-enabled/)
  end

  def expect_photo_to_be_selected(photo)
    expect_photo_carousel_is_closed
    expect(find_photo_element(photo)["class"]).to match(/selected/)
  end

  def expect_photo_to_be_unselected(photo)
    expect_photo_carousel_is_closed
    expect(find_photo_element(photo)["class"]).to_not match(/selected/)
  end
end