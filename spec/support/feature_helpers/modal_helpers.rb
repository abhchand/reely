module FeatureHelpers
  def modal_error
    within(".modal") { page.find(".modal--error").text }
  end

  def expect_modal_is_open
    expect(page).to have_selector(".modal")
  end

  def expect_modal_is_closed
    expect(page).to_not have_selector(".modal")
  end

  def click_modal_submit
    within(".modal") do
      page.find(".modal-content__button--submit").click
    end
  end

  def click_modal_close
    within(".modal") do
      page.find(".modal-content__button--close").click
    end
  end
end
