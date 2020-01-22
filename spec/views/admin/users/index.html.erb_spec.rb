require "rails_helper"

RSpec.describe "admin/users/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @t_prefix = "admin.users.index"

    # rubocop:disable Metrics/LineLength
    stub_template "admin/_breadcrumb_heading.html.erb" => "_stubbed_breadcrumb_heading"
    # rubocop:enable Metrics/LineLength
  end

  it "renders the breadcrumb heading" do
    render
    expect(page).to have_content("_stubbed_breadcrumb_heading")
  end

  it "renders the user manager component" do
    render
    props = { roles: ALL_ROLES }
    expect(page).to(
      have_react_component("admin-user-manager").including_props(props)
    )
  end
end
