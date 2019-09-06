require "rails_helper"

RSpec.describe "account/profile/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_view_context
    stub_template "layouts/_flash.html.erb" => "_stubbed_flash"

    assign(:user, user)

    @t_prefix = "account.profile.index"
  end

  it "renders the flash" do
    render
    expect(rendered).to have_content("_stubbed_flash")
  end

  it "renders the heading" do
    render

    expect(page).to have_content(t("#{@t_prefix}.heading", name: user.name))
  end
end
