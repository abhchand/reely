require "rails_helper"

RSpec.feature "photo manager remove from collection", type: :feature do
  let(:user) { create(:user) }

  let!(:collection) do
    create_collection_with_photos(owner: user, photo_count: 3).tap do |c|
      c.photos.each_with_index do |photo, i|
        photo.update!(taken_at: i.days.ago)
      end
    end
  end

  let(:photos) { collection.photos }

  before do
    @t_prefix = "components.photo_manager.control_panel.remove_from_collection"
  end

  it "user can only remove from collection after selecting a photo", :js do
    log_in(user)
    visit collection_path(collection)

    enable_selection_mode

    expect_remove_from_collection_icon_to_not_be_visible
    click_photo(photos[0])
    expect_remove_from_collection_icon_to_be_visible
    click_photo(photos[0])
    expect_remove_from_collection_icon_to_not_be_visible
  end

  it "user can only remove from collection on Collections show page", :js do
    log_in(user)

    visit photos_path

    enable_selection_mode
    expect_remove_from_collection_icon_to_not_be_visible
    click_photo(photos[0])
    expect_remove_from_collection_icon_to_not_be_visible

    visit collections_sharing_display_path(id: collection.share_id)

    enable_selection_mode
    expect_remove_from_collection_icon_to_not_be_visible
    click_photo(photos[0])
    expect_remove_from_collection_icon_to_not_be_visible

    visit collection_path(collection)

    enable_selection_mode
    expect_remove_from_collection_icon_to_not_be_visible
    click_photo(photos[0])
    expect_remove_from_collection_icon_to_be_visible
  end

  it "user can remove a single photo", :js do
    log_in(user)

    visit collection_path(collection)
    enable_selection_mode

    # Phot Count and Date Range Label (BEFORE)
    expect_photo_count_display_to_be(3)
    expect_date_range_label_for(collection.photos)

    click_photo(photos[1])
    remove_from_collection_icon.click
    wait_for { collection.reload.photos.count == 2 }

    # Check for action notification immediately since it times out
    expect(page).
      to have_action_notification(t("#{@t_prefix}.success", count: 1)).
      of_type(:success)

    # Photo Count and Date Range Label (AFTER)
    expect_photo_count_display_to_be(2)
    expect_date_range_label_for(collection.photos)

    validate_photo_display(collection.photos)
  end

  it "user can remove multiple photos", :js do
    log_in(user)

    visit collection_path(collection)
    enable_selection_mode

    # Phot Count and Date Range Label (BEFORE)
    expect_photo_count_display_to_be(3)
    expect_date_range_label_for(collection.photos)

    click_photo(photos[0])
    click_photo(photos[1])
    remove_from_collection_icon.click
    wait_for { collection.reload.photos.count == 1 }

    # Check for action notification immediately since it times out
    expect(page).
      to have_action_notification(t("#{@t_prefix}.success", count: 2)).
      of_type(:success)

    # Photo Count and Date Range Label (AFTER)
    expect_photo_count_display_to_be(1)
    expect_date_range_label_for(collection.photos)

    validate_photo_display(collection.photos)
  end

  it "user can remove all photos in a collection", :js do
    log_in(user)

    visit collection_path(collection)
    enable_selection_mode

    # Phot Count and Date Range Label (BEFORE)
    expect_photo_count_display_to_be(3)
    expect_date_range_label_for(collection.photos)

    click_photo(photos[0])
    click_photo(photos[1])
    click_photo(photos[2])
    remove_from_collection_icon.click
    wait_for { collection.reload.photos.count.zero? }

    # Check for action notification immediately since it times out
    expect(page).
      to have_action_notification(t("#{@t_prefix}.success", count: 3)).
      of_type(:success)

    # Photo Count and Date Range Label (AFTER)
    expect_photo_count_display_to_be(0)
    expect_date_range_label_for(collection.photos)

    validate_photo_display(collection.photos)
  end

  context "removing a photo is unsuccesful" do
    let(:service) { double("RemovePhotosFromCollection") }

    before do
      expect(RemovePhotosFromCollection).to receive(:call) { service }
      allow(service).to receive(:success?) { false }
    end

    it "displays an action notification", :js do
      log_in(user)

      visit collection_path(collection)
      enable_selection_mode

      # Phot Count and Date Range Label (BEFORE)
      expect_photo_count_display_to_be(3)
      expect_date_range_label_for(collection.photos)

      click_photo(photos[1])
      remove_from_collection_icon.click
      wait_for { collection.reload.photos.count == 3 }

      # Check for action notification immediately since it times out
      expect(page).
        to have_action_notification(t("#{@t_prefix}.error")).
        of_type(:error)

      # Photo Count and Date Range Label (AFTER)
      expect_photo_count_display_to_be(3)
      expect_date_range_label_for(collection.photos)

      validate_photo_display(collection.photos)
    end
  end

  def expect_date_range_label_for(photos)
    actual = page.find(".collections-show__date-range", visible: :all).text
    expected = DateRangeLabelService.call(photos) || ""

    expect(actual).to eq(expected)
  end

  def expect_photo_count_display_to_be(count)
    expected = strip_tags(I18n.t("shared.photo_count.label", count: count))
    actual = page.find(".photo-count").text

    expect(actual).to eq(expected)
  end

  def validate_photo_display(photos)
    expect(displayed_photo_ids).to match_array(photos.map(&:synthetic_id))
  end
end
