require "rails_helper"

RSpec.feature "Mobile Navigation", type: :feature do
  let(:user) { create(:user) }

  before { @t_prefix = "application.mobile_navigation" }

  context "mobile", :mobile, js: true do
    it "user can open the menu and click a link" do
      log_in(user)
      expect_menu_is_closed

      click_menu_icon
      expect_menu_is_open

      click_link(t("#{@t_prefix}.links.log_out"))
      expect(page).to have_current_path(root_path)
    end

    describe "closing the menu" do
      before do
        log_in(user)
        click_menu_icon
        expect_menu_is_open
      end

      it "user can close the menu by clicking the close button" do
        find(".mobile-navigation__footer").click
        expect_menu_is_closed
      end

      it "user can close the menu by clicking the overlay" do
        # The overlay is 400x730 in size
        # `click` by default clicks on the center of the element, but in this
        # case the overlay is covered by the menu itself and is not clickable
        # Manually specify a coordinate *offset* to click on

        find(".mobile-navigation__overlay").click(x: 200, y: 600)
        expect_menu_is_closed
      end
    end
  end

  def click_menu_icon
    find(".mobile-navigation__menu-icon").click
    wait_for_ajax
  end

  def expect_menu_is_closed
    wait_for_ajax

    # Menu
    css_prefix = ".mobile-navigation__links-container"
    expect(page).to have_css("#{css_prefix}.inactive", visible: false)
    expect(page).to_not have_css("#{css_prefix}.active")

    # Overlay
    css_prefix = ".mobile-navigation__overlay"
    expect(page).to have_css("#{css_prefix}.inactive", visible: false)
    expect(page).to_not have_css("#{css_prefix}.active")
  end

  def expect_menu_is_open
    wait_for_ajax

    # Menu
    css_prefix = ".mobile-navigation__links-container"
    expect(page).to have_css("#{css_prefix}.active", visible: true)
    expect(page).to_not have_css("#{css_prefix}.inactive")

    # Overlay
    css_prefix = ".mobile-navigation__overlay"
    expect(page).to have_css("#{css_prefix}.active", visible: true)
    expect(page).to_not have_css("#{css_prefix}.inactive")
  end
end
