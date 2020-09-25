require 'rails_helper'

RSpec.feature 'photo selection', type: :feature do
  let(:user) { create(:user) }
  let(:photo_count) { 3 }

  let!(:photos) do
    create_list(:photo, photo_count, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  it 'user can select and unselect photos', :js do
    log_in(user)
    visit photos_path

    enable_selection_mode

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

  it 'clears any selected photos when selection mode is disabled', :js do
    log_in(user)
    visit photos_path

    enable_selection_mode

    click_photo(photos[0])
    expect_photo_to_be_selected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_unselected(photos[2])

    disable_selection_mode
    enable_selection_mode

    expect_photo_to_be_unselected(photos[0])
    expect_photo_to_be_unselected(photos[1])
    expect_photo_to_be_unselected(photos[2])
  end

  describe 'bulk selection with shift + click', :js do
    let(:photo_count) { 4 }

    it 'user can bulk select forwards and backwards' do
      log_in(user)
      visit photos_path

      enable_selection_mode

      # Forwards
      click_photo(photos[1])
      shift_click_photo(photos[3])
      expect_photo_to_be_unselected(photos[0])
      expect_photo_to_be_selected(photos[1])
      expect_photo_to_be_selected(photos[2])
      expect_photo_to_be_selected(photos[3])

      # Backwards
      shift_click_photo(photos[0])
      expect_photo_to_be_selected(photos[0])
      expect_photo_to_be_selected(photos[1])
      expect_photo_to_be_unselected(photos[2])
      expect_photo_to_be_unselected(photos[3])
    end

    context 'no photos are selected already' do
      it "bulk select has no effect, it's the same as selecting a one photo" do
        log_in(user)
        visit photos_path

        enable_selection_mode

        shift_click_photo(photos[2])
        expect_photo_to_be_unselected(photos[0])
        expect_photo_to_be_unselected(photos[1])
        expect_photo_to_be_selected(photos[2])
        expect_photo_to_be_unselected(photos[3])
      end
    end

    context 'a range of photos are selected already' do
      let(:photo_count) { 5 }

      it 'user can bulk select forwards, backwards, and within the range' do
        log_in(user)
        visit photos_path

        enable_selection_mode

        # Within the range
        click_photo(photos[1])
        click_photo(photos[2])
        click_photo(photos[3])
        shift_click_photo(photos[2])
        expect_photo_to_be_unselected(photos[0])
        expect_photo_to_be_selected(photos[1])
        expect_photo_to_be_selected(photos[2])
        expect_photo_to_be_unselected(photos[3])
        expect_photo_to_be_unselected(photos[4])

        # Forward
        shift_click_photo(photos[4])
        expect_photo_to_be_unselected(photos[0])
        expect_photo_to_be_selected(photos[1])
        expect_photo_to_be_selected(photos[2])
        expect_photo_to_be_selected(photos[3])
        expect_photo_to_be_selected(photos[4])

        # Backwards
        shift_click_photo(photos[0])
        expect_photo_to_be_selected(photos[0])
        expect_photo_to_be_selected(photos[1])
        expect_photo_to_be_unselected(photos[2])
        expect_photo_to_be_unselected(photos[3])
        expect_photo_to_be_unselected(photos[4])
      end
    end
  end
end
