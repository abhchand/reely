require "rails_helper"

RSpec.feature "photo manager carousel", type: :feature do
  let(:user) { create(:user) }

  let!(:photos) do
    create_list(:photo, 3, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  it "user can navigate forwards and backwards through all photos", :js do
    log_in(user)
    visit photos_path

    # Clicking next

    click_photo(photos[0])
    expect_photo_carousel_to_display(photos[0])

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[1])

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[2])

    # Looping back to first photo

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[0])

    # Looping back to last photo

    click_photo_carousel_prev
    expect_photo_carousel_to_display(photos[2])

    # Clicking previous

    click_photo_carousel_prev
    expect_photo_carousel_to_display(photos[1])

    # Navigating next with Right Arrow
    find("body").send_keys(:right)
    expect_photo_carousel_to_display(photos[2])

    # Navigating previous with Left Arrow
    find("body").send_keys(:left)
    expect_photo_carousel_to_display(photos[1])

    # Navigating next with 'j'
    find("body").send_keys("j")
    expect_photo_carousel_to_display(photos[2])

    # Navigating previous 'k'
    find("body").send_keys("k")
    expect_photo_carousel_to_display(photos[1])
  end

  it "user can close the photo carousel", :js do
    log_in(user)
    visit photos_path

    # Clicking Close button

    click_photo(photos[1])
    expect_photo_carousel_to_display(photos[1])

    close_photo_carousel
    expect_photo_carousel_is_closed

    # Press Escape

    click_photo(photos[1])
    expect_photo_carousel_to_display(photos[1])

    find("body").send_keys(:escape)
    expect_photo_carousel_is_closed
  end

  it "only considers photos owned by this user", :js do
    # Create photo owned by another user
    create(:photo)

    log_in(user)
    visit photos_path

    # Clicking next

    click_photo(photos[0])
    expect_photo_carousel_to_display(photos[0])

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[1])

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[2])

    # Looping back to first photo

    click_photo_carousel_next
    expect_photo_carousel_to_display(photos[0])
  end

  describe "photo orientation", :js do
    it "displays the photo with correct orientation" do
      photos[0].exif_data["orientation"] = "Rotate 90 CW"
      photos[1].exif_data["orientation"] = "Horizontal (normal)"
      photos[2].exif_data["orientation"] = nil
      photos.map(&:save!)

      log_in(user)
      visit photos_path

      click_photo(photos[0])
      style = page.find(".photo-carousel__current-photo")["style"]
      expect(style).to match(/transform:\s?rotate\(90deg\);/)

      click_photo_carousel_next
      style = page.find(".photo-carousel__current-photo")["style"]
      expect(style).to_not match(/transform:\s?rotate/)

      click_photo_carousel_next
      style = page.find(".photo-carousel__current-photo")["style"]
      expect(style).to_not match(/transform:\s?rotate/)
    end
  end
end
