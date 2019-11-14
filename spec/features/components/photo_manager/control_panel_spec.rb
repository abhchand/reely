require "rails_helper"

RSpec.feature "photo manager control panel", type: :feature do
  let(:user) { create(:user) }

  let!(:photos) do
    create_list(:photo, 2, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  before do
    @t_prefix = "components.photo_manager.control_panel"
  end

  it "user can open and close the control panel", :js do
    log_in(user)
    visit photos_path

    enable_selection_mode
    disable_selection_mode
  end

  it "photo selection count updates as the user selects photos", :js do
    log_in(user)
    visit photos_path

    enable_selection_mode
    expect_photo_selection_count_to_be(0)

    click_photo(photos[0])
    expect_photo_selection_count_to_be(1)

    click_photo(photos[1])
    expect_photo_selection_count_to_be(2)

    click_photo(photos[1])
    expect_photo_selection_count_to_be(1)

    click_photo(photos[0])
    expect_photo_selection_count_to_be(0)
  end

  def expect_photo_selection_count_to_be(count)
    element = page.find(".photo-grid-control-panel__selected-photo-count")
    expect(element).to have_content(
      t("#{@t_prefix}.selected_photo_count.heading", count: count)
    )
  end
end
