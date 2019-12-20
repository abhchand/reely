require "rails_helper"

RSpec.describe "application/_mobile_navigation.html.erb", type: :view do
  let(:user) { create(:user) }
  let(:user_presenter) { UserPresenter.new(user, view: view_context) }

  before do
    stub_view_context
    stub_current_user

    @t_prefix = "application.mobile_navigation"
  end

  it "displays the user's profile" do
    render

    profile = page.find(".mobile-navigation__profile")

    # Profile Picture
    expect(profile.find("a")["href"]).to eq(root_path)
    expect(profile.find("img")["src"]).
      to eq(user_presenter.avatar_path(size: :thumb))

    # User Name
    expect(profile.find("span")).to have_content(user.first_name.downcase)
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
      [t("#{@t_prefix}.links.account"), account_profile_index_path],
      [t("#{@t_prefix}.links.product_feedback"), "#"],
      [t("#{@t_prefix}.links.log_out"), destroy_user_session_path]
    ]

    page.all(".mobile-navigation__link-element").each do |el|
      link = el.find("a")
      actual_links << [link.text.strip, link["href"]]
    end

    expect(expected_links).to eq(actual_links)
  end

  it "renders the close link" do
    render

    expect(page).to have_selector(".mobile-navigation__close > svg")
  end
end
