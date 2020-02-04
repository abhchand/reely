require "rails_helper"

RSpec.describe "application/_desktop_navigation.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @t_prefix = "application.desktop_navigation"
    forward_can_method_to(user)
  end

  it "renders the logo" do
    render

    logo = page.find(".desktop-navigation__logo")

    expect(logo.find("a")["href"]).to eq(root_path)
    expect(logo).to have_selector("svg")
  end

  it "renders the navigation links" do
    render

    actual_links = rendered_links
    expected_links = [
      photos_path,
      "#",
      "#",
      "#",
      new_photo_path,
      collections_path,
      account_profile_index_path,
      "#",
      destroy_user_session_path
    ]

    expect(expected_links).to eq(actual_links)
  end

  context "user can access admin pages" do
    before { user.add_role(:admin) }

    it "renders the admin index link" do
      render
      expect(rendered_links).to include(admin_index_path)
    end
  end

  def rendered_links
    [].tap do |links|
      page.all(".desktop-navigation__link-element").each do |el|
        links << el.find("a")["href"]
      end
    end
  end
end
