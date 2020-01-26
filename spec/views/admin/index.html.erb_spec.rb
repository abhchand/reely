require "rails_helper"

RSpec.describe "admin/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @t_prefix = "admin.index"
  end

  it "renders the admin links" do
    render

    actual_links = []
    expected_links = [
      admin_users_path,
      admin_audits_path
    ]

    page.all(".admin-index__link-element").each do |el|
      link = el.find("a")
      actual_links << link["href"]
    end

    expect(expected_links).to eq(actual_links)
  end
end
