require "rails_helper"

RSpec.describe "application/_mobile_header.html.erb", type: :view do
  before { @t_prefix = "application.mobile_navigation" }

  it "displays a navigation header with a logo and menu icon" do
    render

    header = page.find(".mobile-header")

    logo = header.find(".mobile-header__logo > a")
    expect(logo["href"]).to eq(root_path)
    expect(logo).to have_selector("svg")

    menu_icon = header.find(".mobile-header__menu-icon")
    expect(menu_icon).to have_selector("svg")
  end
end
