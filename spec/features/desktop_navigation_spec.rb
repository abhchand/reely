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

    click_to_collapse
    expect_navigation_is_collapsed

    click_to_expand
    expect_navigation_is_expanded
  end

  def click_to_collapse
    page.find(".desktop-navigation__collapser--expanded").click
  end

  def click_to_expand
    page.find(".desktop-navigation__collapser--collapsed").click
  end

  def expect_navigation_is_collapsed
    collapsed = page.find(".desktop-navigation__collapser--collapsed")
    expanded = page.find(
      ".desktop-navigation__collapser--expanded",
      visible: false
    )

    expanded_classes = expanded["class"].split(" ")
    collapsed_classes = collapsed["class"].split(" ")

    expect(collapsed_classes).to include("active")
    expect(collapsed_classes).to_not include("inactive")

    expect(expanded_classes).to include("inactive")
    expect(expanded_classes).to_not include("active")

    %w[.desktop-navigation__logo .desktop-navigation__links].each do |c|
      expect(page).to have_selector(c, visible: false)
    end
  end

  def expect_navigation_is_expanded
    expanded = page.find(".desktop-navigation__collapser--expanded")
    collapsed = page.find(
      ".desktop-navigation__collapser--collapsed",
      visible: false
    )

    expanded_classes = expanded["class"].split(" ")
    collapsed_classes = collapsed["class"].split(" ")

    expect(expanded_classes).to include("active")
    expect(expanded_classes).to_not include("inactive")

    expect(collapsed_classes).to include("inactive")
    expect(collapsed_classes).to_not include("active")

    %w[.desktop-navigation__logo .desktop-navigation__links].each do |c|
      expect(page).to have_selector(c, visible: true)
    end
  end
end
