module FeatureHelpers
  def find_photo_element(photo)
    find(".photo-grid__photo-container[data-id='#{photo.synthetic_id}']")
  end

  def click_photo(photo)
    find_photo_element(photo).click
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
    photo_el = find(".photo-carousel__content")

    expect(photo_el["data-id"]).to eq(photo.synthetic_id)
    expect(photo_el["style"]).
      to eq("background-image: url(\"#{photo.source_file_path}\");")
  end

  def expect_photo_carousel_is_closed
    expect(page).to_not have_selector(".photo-carousel")
  end

  #
  # Photo Selection
  #

  def enable_edit_mode
    find(".photo-grid__edit-toggle").click
    photo_grid_el = page.find(".photo-grid")
    expect(photo_grid_el["class"]).to match(/photo-grid--edit-mode-enabled/)
  end

  def disable_edit_mode
    find(".photo-grid__edit-toggle").click
    photo_grid_el = page.find(".photo-grid")
    expect(photo_grid_el["class"]).to_not match(/photo-grid--edit-mode-enabled/)
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
