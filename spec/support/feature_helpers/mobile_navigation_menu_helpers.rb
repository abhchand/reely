module FeatureHelpers
  def click_mobile_menu_icon
    find('.mobile-header__menu-icon').click
    wait_for_ajax
  end

  def expect_mobile_menu_is_closed
    wait_for_ajax

    expect(page).to have_selector('.mobile-navigation')
    expect(page).to have_selector('.mobile-navigation__overlay', visible: false)
  end

  def expect_mobile_menu_is_open
    wait_for_ajax

    expect(page).to have_selector('.mobile-navigation')
    expect(page).to have_selector('.mobile-navigation__overlay')
  end
end
