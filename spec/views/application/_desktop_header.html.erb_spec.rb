require "rails_helper"

RSpec.describe "application/_desktop_header.html.erb", type: :view do
  let(:user) { create(:user) }

  before { allow(view).to receive(:current_user) { user } }

  it "renders the logo" do
    render

    logo = page.find(".desktop-header__image--logo")

    expect(logo.find("a")["href"]).to eq(root_path)
    expect(logo).to have_selector("svg")
  end

  it "renders the profile pic" do
    render

    expect(page.find(".desktop-header__image--profile-pic > a")["href"]).
      to eq(root_path)
    expect(page.find(".desktop-header__image--profile-pic img")["src"]).
      to eq(user.avatar_url)
  end
end
