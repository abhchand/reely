require "rails_helper"

RSpec.describe "application/_desktop_navigation.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    stub_current_user
    @t_prefix = "application.desktop_navigation"
  end

  it "renders the navigation links" do
    render

    actual_links = []
    expected_links = [
      [t("#{@t_prefix}.links.my_photos"), photos_path],
      [t("#{@t_prefix}.links.locations"), "#"],
      [t("#{@t_prefix}.links.people"), "#"],
      [t("#{@t_prefix}.links.favorites"), "#"],
      [t("#{@t_prefix}.links.collections"), collections_path],
      [t("#{@t_prefix}.links.settings"), "#"],
      [t("#{@t_prefix}.links.log_out"), log_out_path]
    ]

    page.all(".desktop-navigation__link-element").each do |el|
      link = el.find("a")
      actual_links << [link.text.strip, link["href"]]
    end

    expect(expected_links).to eq(actual_links)
  end
end
