require "rails_helper"

RSpec.describe "admin/users/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @t_prefix = "admin.users.index"
  end

  it "renders the user list" do
    render
    props = {}
    expect(page).to(
      have_react_component("admin-user-list").including_props(props)
    )
  end
end
