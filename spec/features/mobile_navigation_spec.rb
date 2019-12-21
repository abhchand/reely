require "rails_helper"

RSpec.feature "Mobile Navigation", type: :feature do
  let(:user) { create(:user) }

  before { @t_prefix = "application.mobile_navigation" }

  context "mobile", :mobile, js: true do
    it "user can open the menu and click a link" do
      log_in(user)
      expect_mobile_menu_is_closed

      click_mobile_menu_icon
      expect_mobile_menu_is_open

      click_link(t("#{@t_prefix}.links.log_out"))
      expect(page).to have_current_path(new_user_session_path)
    end

    describe "closing the menu" do
      before do
        log_in(user)
        click_mobile_menu_icon
        expect_mobile_menu_is_open
      end

      it "user can close the menu by clicking the close button" do
        find(".mobile-navigation__close").click
        expect_mobile_menu_is_closed
      end

      it "user can close the menu by clicking the overlay" do
        # The overlay is 400x730 in size (100% filling the mobile window)
        # `click` by default clicks on the center of the element, but in this
        # case the overlay is covered by the menu itself and is not clickable
        # Manually specify a coordinate *offset* to click on

        find(".mobile-navigation__overlay").click(x: 200, y: 600)
        expect_mobile_menu_is_closed
      end
    end
  end
end
