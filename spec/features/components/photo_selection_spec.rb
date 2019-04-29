require "rails_helper"

RSpec.feature "photo selection", type: :feature do
  let(:user) { create(:user) }

  let!(:photos) do
    create_list(:photo, 3, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  it "user can select and unselect photos", :js do
    log_in(user)
    visit photos_path

    enable_edit_mode

    click_photo(photos[0])
    expect_photo_to_be_selected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_unselected(photos[2])

    click_photo(photos[2])
    expect_photo_to_be_selected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_selected(photos[2])

    click_photo(photos[0])
    expect_photo_to_be_unselected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_selected(photos[2])
  end

  it "clears any selected photos when edit mode is disabled", :js do
    log_in(user)
    visit photos_path

    enable_edit_mode

    click_photo(photos[0])
    expect_photo_to_be_selected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_unselected(photos[2])

    disable_edit_mode
    enable_edit_mode

    expect_photo_to_be_unselected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_unselected(photos[2])
  end

  describe "keyboard navigation" do
    it "user can disable edit mode using the Escape key", :js do
      log_in(user)
      visit photos_path

      enable_edit_mode
      click_photo(photos[0])

      pg = page.find(".photo-grid")

      expect(pg["class"]).to match(/photo-grid--edit-mode-enabled/)
      pg.send_keys(:escape)
      expect(pg["class"]).to_not match(/photo-grid--edit-mode-enabled/)
    end
  end
end
