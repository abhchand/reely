require "rails_helper"

RSpec.describe "collections/_share_modal.html.erb", type: :view do
  before { @t_prefix = "collections.share_modal" }

  it "renders the modal and modal content" do
    render_partial

    within(".collections-share-modal") do
      heading = page.find(".modal-content__heading")
      expect(heading).to have_content(t("#{@t_prefix}.heading_default"))

      body = page.find(".modal-content__body")
      expect(body).to have_content(t("#{@t_prefix}.body"))

      close = page.find(".modal-content__button--close")
      expect(close.value).to eq(t("#{@t_prefix}.close").downcase)
    end
  end

  def render_partial
    render(partial: "collections/share_modal")
  end
end
