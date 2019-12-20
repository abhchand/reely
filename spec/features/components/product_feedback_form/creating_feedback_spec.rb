require "rails_helper"

RSpec.feature "creating product feedback", type: :feature do
  let(:user) { create(:user) }

  before do
    log_in(user)
    visit photos_path
  end

  it "user can leave product feedback", :js do
    open_feedback_modal_on_desktop
    fill_in("product_feedback[body]", with: "Some feedback")

    click_submit
    wait_for { ProductFeedback.count == 1 }

    pf = ProductFeedback.last
    expect(pf.user).to eq(user)
    expect(pf.body).to eq("Some feedback")

    # TBD: Expect modal closed
  end

  it "validates the feedback", :js do
    open_feedback_modal_on_desktop
    fill_in("product_feedback[body]", with: "")

    click_submit

    message = validation_error_for(:body, :blank, klass: ProductFeedback)
    expect(error_text).to eq(message)
  end

  context "mobile", :mobile, js: true do
    it "user can leave product feedback" do
      open_feedback_modal_on_mobile
      fill_in("product_feedback[body]", with: "Some feedback")

      click_submit
      wait_for { ProductFeedback.count == 1 }

      pf = ProductFeedback.last
      expect(pf.user).to eq(user)
      expect(pf.body).to eq("Some feedback")

      # TBD: Expect modal closed
    end
  end

  def open_feedback_modal_on_desktop
    page.find(".desktop-navigation__link-element--product-feedback").click
  end

  def open_feedback_modal_on_mobile
    find(".mobile-header__menu-icon").click
    wait_for_ajax
    page.find(".mobile-navigation__link-element--product-feedback").click
  end

  def error_text
    page.find(".modal-content__error").text
  end

  def click_submit
    within(".modal") do
      page.find(".modal-content__button--submit").click
    end
  end
end
