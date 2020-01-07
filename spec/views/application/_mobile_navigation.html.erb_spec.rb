require "rails_helper"

RSpec.describe "application/_mobile_navigation.html.erb", type: :view do
  let(:user) { create(:user) }
  let(:user_presenter) { UserPresenter.new(user, view: view_context) }

  before do
    stub_view_context
    stub_current_user
    forward_can_method_to(user)

    @t_prefix = "application.mobile_navigation"
  end

  it "displays the user's profile" do
    render

    profile = page.find(".mobile-navigation__profile")

    # Profile Picture
    expect(profile.find("a")["href"]).to eq(root_path)
    expect(profile.find("img")["src"]).
      to eq(user_presenter.avatar_path(size: :thumb))

    # User Name
    expect(profile.find("span")).to have_content(user.first_name.downcase)
  end

  it "renders the navigation links" do
    render

    actual_links = rendered_links
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

    expect(expected_links).to eq(actual_links)
  end

  it "renders the close link" do
    render

    expect(page).to have_selector(".mobile-navigation__close > svg")
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
      page.all(".mobile-navigation__link-element").each do |el|
        links << el.find("a")["href"]
      end
    end
  end
end
