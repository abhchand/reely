require "rails_helper"

RSpec.describe "application/_desktop_navigation.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_current_user
    @t_prefix = "application.desktop_navigation"
  end

  it "renders the logo" do
    render

    logo = page.find(".desktop-navigation__logo")

    expect(logo.find("a")["href"]).to eq(root_path)
    expect(logo).to have_selector("svg")
  end

  it "renders the navigation links" do
    render

    actual_links = []
    expected_links = [
      photos_path,
      "#",
      "#",
      "#",
      collections_path,
      account_profile_index_path,
      "#",
      destroy_user_session_path
    ]

    page.all(".desktop-navigation__link-element").each do |el|
      link = el.find("a")
      actual_links << link["href"]
    end

    expect(expected_links).to eq(actual_links)
  end
end
