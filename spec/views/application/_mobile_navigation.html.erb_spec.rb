require "rails_helper"

RSpec.describe "application/_mobile_navigation.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_current_user
    @t_prefix = "application.mobile_navigation"
  end

  it "displays a navigation header with a logo and menu icon" do
    render

    header = page.find(".mobile-navigation__header")

    logo = header.find(".mobile-navigation__logo > a")
    expect(logo["href"]).to eq(root_path)
    expect(logo).to have_selector("svg")

    menu_icon = header.find(".mobile-navigation__menu-icon")
    expect(menu_icon).to have_selector("svg")
  end

  it "displays the user's profile" do
    render

    profile = page.find(".mobile-navigation__profile")

    # Profile Picture
    expect(profile.find("a")["href"]).to eq(root_path)
    expect(profile.find("img")["src"]).to eq(user.avatar_url(:thumb))

    # User Name
    expect(profile.find("span")).to have_content(user.first_name.downcase)
  end

  it "renders the navigation links" do
    render

    actual_links = []
    expected_links = [
      [t("#{@t_prefix}.links.my_photos"), home_index_path],
      [t("#{@t_prefix}.links.locations"), "#"],
      [t("#{@t_prefix}.links.people"), "#"],
      [t("#{@t_prefix}.links.favorites"), "#"],
      [t("#{@t_prefix}.links.collections"), collections_path],
      [t("#{@t_prefix}.links.settings"), "#"],
      [t("#{@t_prefix}.links.log_out"), log_out_path]
    ]

    page.all(".mobile-navigation__link-element").each do |el|
      link = el.find("a")
      actual_links << [link.text.strip, link["href"]]
    end

    expect(expected_links).to eq(actual_links)
  end
end
