require "rails_helper"

RSpec.feature "Flash message", type: :feature do
  let!(:user) { create(:user) }

  it "displays the flash message and close 'link'" do
    visit root_path

    click_submit

    expected_message = [
      t("sessions.create.authenticate.blank_email"),
      t("layouts.flash.close")
    ].join(" ")

    expect(find(".flash")).to be_visible
    expect(find(".flash .flash__message").text).to eq(expected_message)
    expect(find(".flash .flash__message .close").text).
      to eq(t("layouts.flash.close"))
  end

  it "allows the user to close the flash", js: true do
    visit root_path

    click_submit
    find(".flash").click

    expect(page).to_not have_selector(".flash")
  end

  def click_submit
    click_button(t("site.index.form.submit"))
  end
end
