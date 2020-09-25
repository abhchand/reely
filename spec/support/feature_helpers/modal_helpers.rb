module FeatureHelpers
  def modal_error
    within('.modal') { page.find('.modal--error').text }
  end

  def expect_modal_is_open(async: false)
    if async
      wait_for(4) { !page.all('.modal').count.zero? }
    else
      expect(page).to have_selector('.modal')
    end
  end

  def expect_modal_is_closed(async: false)
    if async
      wait_for(4) { page.all('.modal').count.zero? }
    else
      expect(page).to_not have_selector('.modal')
    end
  end

  def click_modal_submit
    within('.modal') { page.find('.modal-content__button--submit').click }
  end

  def click_modal_close
    within('.modal') { page.find('.modal-content__button--close').click }
  end
end
