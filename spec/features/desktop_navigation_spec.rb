require "rails_helper"

RSpec.feature "Desktop Navigation", type: :feature do
  let(:user) { create(:user) }

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
    expect(page).to have_selector(".desktop-navigation__links", visible: false)
  end

  def expect_navigation_is_expanded
    expect(page).to_not have_selector(".desktop-navigation--collapsed")
    expect(page).to have_selector(".desktop-navigation__links", visible: true)
  end
end
