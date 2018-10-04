require "rails_helper"

RSpec.describe "collections/_delete_modal.html.erb", type: :view do
  before { @t_prefix = "collections.delete_modal" }

  it "renders the modal and modal content" do
    render_partial

    heading = page.find(".modal-content__heading")
    expect(heading).to have_content(t("#{@t_prefix}.heading_default"))

    body = page.find(".modal-content__body")
    expect(body).to have_content(t("#{@t_prefix}.body"))

    cancel = page.find(".modal-content__button--cancel")
    expect(cancel.value).to eq(t("#{@t_prefix}.cancel").downcase)

    delete = page.find(".modal-content__button--submit")
    expect(delete.value).to eq(t("#{@t_prefix}.delete").downcase)
  end

  def render_partial
    render(partial: "collections/delete_modal")
  end
end
