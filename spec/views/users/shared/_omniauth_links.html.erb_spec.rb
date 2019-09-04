require "rails_helper"

RSpec.describe "users/shared/_omniauth_links.html.erb", type: :view do
  it "renders the omniauth links" do
    render

    User::OMNIAUTH_PROVIDERS.each do |provider|
      href = send("user_#{provider}_omniauth_authorize_path")
      expect(page).to have_selector("a[href='#{href}']")
    end
  end
end
