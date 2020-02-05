require "rails_helper"

RSpec.feature "photo selection", type: :feature do
  let(:user) { create(:user) }

  before { @t_prefix = "components.photo_manager.empty" }

  it "user is shown empty state and can follow link to add photos", :js do
    log_in(user)
    visit photos_path

    empty = page.find(".photo-manager--emtpy")

    within(empty) do
      expect(page.find(".heading")).to have_content(t("#{@t_prefix}.heading"))
      expect(page).
        to have_link(t("#{@t_prefix}.add_photos"), href: new_photo_path)
    end

    empty.find(".add-photos").click
    expect(page).to have_current_path(new_photo_path)
  end
end
