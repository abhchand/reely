require "rails_helper"

RSpec.feature "Logging In", type: :feature do
  let(:user) { create(:user, password: password) }
  let(:password) { "kingK0ng" }

  before { user }

  it "user can log in"do
    visit root_path

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: password
    click_submit

    expect(page).to have_current_path(home_index_path)
  end

  it "preserves user destination for deep-linking" do
    visit collections_path

    expect(current_path).to eq(root_path)
    expect(url_params[:dest]).to eq(collections_path)

    # Failed Login Attempt

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: "badPassword"
    click_submit

    expect(current_path).to eq(root_path)
    expect(url_params[:dest]).to eq(collections_path)

    # Successful Login Attempt

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: password
    click_submit

    expect(page).to have_current_path(collections_path)
  end

  describe "form validation" do
    it "user receives form validation on submit" do
      visit root_path

      click_submit

      expect(find(".flash__message").text).
        to eq(t("sessions.create.authenticate.blank_email"))
    end
  end

  def click_submit
    click_button(t("site.index.form.submit"))
  end
end
