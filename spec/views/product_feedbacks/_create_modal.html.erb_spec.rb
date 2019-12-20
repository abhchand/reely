require "rails_helper"

RSpec.describe "product_feedbacks/_create_modal.html.erb", type: :view do
  before { @t_prefix = "product_feedbacks.create_modal" }

  it "renders the modal and modal content" do
    render_partial

    within(".product_feedbacks-create-modal") do
      close = page.find(".modal-content__button--close")
      expect(close.value).to eq(t("#{@t_prefix}.close").downcase)
    end
  end

  def render_partial
    render(partial: "product_feedbacks/create_modal")
  end
end
