require "rails_helper"

RSpec.describe "account/profile/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_view_context

    assign(:user, user)

    @t_prefix = "account.profile.index"
  end

  it "renders the heading" do
    render

    expect(page).to have_content(t("#{@t_prefix}.heading", name: user.name))
  end
end
