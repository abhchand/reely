require "rails_helper"

RSpec.feature "Desktop Navigation", type: :feature do
  let(:user) { create(:user) }

  describe "navigation header" do
    it "renders the profile picture" do
      log_in(user)

      profile = page.find(".desktop-navigation__profile-pic")

      # Profile Picture
      expect(profile.find("a")["href"]).to eq(root_path)
      expect(profile.find("img")["src"]).to eq(user.avatar_url(:thumb))
    end
  end

  it "user can collapse and uncollapse the navbar", js: true do
    log_in(user)
    expect_navigation_is_expanded

    toggle_collapse
    expect_navigation_is_collapsed

    toggle_collapse
    expect_navigation_is_expanded
  end

  def toggle_collapse
    page.find(".desktop-navigation__toggle").click
  end

  def expect_navigation_is_collapsed
    expect(page).to have_selector(".desktop-navigation--collapsed")

    %w[.desktop-navigation__logo .desktop-navigation__links].each do |c|
      expect(page).to have_selector(c, visible: false)
    end
  end

  def expect_navigation_is_expanded
    expect(page).to_not have_selector(".desktop-navigation--collapsed")

    %w[.desktop-navigation__logo .desktop-navigation__links].each do |c|
      expect(page).to have_selector(c, visible: true)
    end
  end
end
