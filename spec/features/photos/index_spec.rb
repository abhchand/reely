require "rails_helper"

RSpec.feature "photos index page", type: :feature do
  let(:user) { create(:user) }

  describe "photo carousel", :js do
    let!(:photos) do
      create_list(:photo, 3, owner: user).each_with_index do |photo, i|
        photo.update!(taken_at: i.days.ago)
      end
    end

    it "user can navigate forwards and backwards through all photos" do
      log_in(user)
      visit photos_path

      # Clicking next

      click_photo(photos[0])
      expect_displayed_photo_to_be(photos[0])

      click_next
      expect_displayed_photo_to_be(photos[1])

      click_next
      expect_displayed_photo_to_be(photos[2])

      # Looping back to first photo

      click_next
      expect_displayed_photo_to_be(photos[0])

      # Looping back to last photo

      click_prev
      expect_displayed_photo_to_be(photos[2])

      # Clicking previous

      click_prev
      expect_displayed_photo_to_be(photos[1])

      # Navigating next with Right Arrow
      find(".photo-carousel").send_keys(:right)
      expect_displayed_photo_to_be(photos[2])

      # Navigating previous with Left Arrow
      find(".photo-carousel").send_keys(:left)
      expect_displayed_photo_to_be(photos[1])

      # Navigating next with 'j'
      find(".photo-carousel").send_keys("j")
      expect_displayed_photo_to_be(photos[2])

      # Navigating previous 'k'
      find(".photo-carousel").send_keys("k")
      expect_displayed_photo_to_be(photos[1])
    end

    it "user can close the photo carousel" do
      log_in(user)
      visit photos_path

      # Clicking Close button

      click_photo(photos[1])
      expect_displayed_photo_to_be(photos[1])

      click_close
      expect_photo_carousel_is_closed

      # Press Escape

      click_photo(photos[1])
      expect_displayed_photo_to_be(photos[1])

      find(".photo-carousel").send_keys(:escape)
      expect_photo_carousel_is_closed
    end

    it "only considers photos owned by this user" do
      # Create photo owned by another user
      create(:photo)

      log_in(user)
      visit photos_path

      # Clicking next

      click_photo(photos[0])
      expect_displayed_photo_to_be(photos[0])

      click_next
      expect_displayed_photo_to_be(photos[1])

      click_next
      expect_displayed_photo_to_be(photos[2])

      # Looping back to first photo

      click_next
      expect_displayed_photo_to_be(photos[0])
    end

    def click_photo(photo)
      find(".photo-grid__aspect-ratio[data-id='#{photo.synthetic_id}']").click
    end

    def click_next
      find(".photo-carousel__navigation-container.next").click
    end

    def click_prev
      find(".photo-carousel__navigation-container.prev").click
    end

    def click_close
      find(".photo-carousel__close").click
    end

    def expect_displayed_photo_to_be(photo)
      photo_el = find(".photo-carousel__content")
      photo_url = prepend_host(photo.source.url)

      expect(photo_el["data-id"]).to eq(photo.synthetic_id)
      expect(photo_el["style"]).to eq("background-image: url(#{photo_url});")
    end

    def expect_photo_carousel_is_closed
      expect(page).to_not have_selector(".photo-carousel")
    end
  end
end
