require "rails_helper"

RSpec.describe "application/_desktop_navigation.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_current_user
    @t_prefix = "application.desktop_navigation"
  end

  it "displays the user's profile" do
    render

    profile = page.find(".desktop-navigation__profile")

    # Profile Picture
    expect(profile.find("a")["href"]).to eq(root_path)
    expect(profile.find("img")["src"]).to match(/test-profile.*jpg/)

    # User Name
    expect(profile.find("span")).to have_content(user.first_name.downcase)
  end

  it "renders the navigation links" do
    render

    actual_links = []
    expected_links = [
      [t("#{@t_prefix}.menu.my_photos"), home_index_path],
      [t("#{@t_prefix}.menu.locations"), "#"],
      [t("#{@t_prefix}.menu.people"), "#"],
      [t("#{@t_prefix}.menu.favorites"), "#"],
      [t("#{@t_prefix}.menu.collections"), collections_path],
      [t("#{@t_prefix}.menu.settings"), "#"],
      [t("#{@t_prefix}.menu.log_out"), log_out_path],
    ]

    page.all(".desktop-navigation__link-element").each do |el|
      link = el.find("a")
      actual_links << [link.text.strip, link["href"]]
    end
  end
end
