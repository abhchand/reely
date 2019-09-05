require "rails_helper"

RSpec.describe "users/shared/_omniauth_links.html.erb", type: :view do
  before do
    @t_prefix = "users.shared.omniauth_links"
    allow(controller).to receive(:controller_name) { controller_name }
  end

  context "registrations controller" do
    let(:controller_name) { "registrations" }

    it "renders the omniauth links" do
      render

      User::OMNIAUTH_PROVIDERS.each do |provider|
        href = send("user_#{provider}_omniauth_authorize_path")
        expect(page).to have_selector("a[href='#{href}']")

        label = page.find(".omniauth-btn--#{provider} .label")
        expect(label).
          to have_content(t("#{@t_prefix}.register_with.#{provider}"))
      end
    end
  end

  context "sessions controller" do
    let(:controller_name) { "sessions" }

    it "renders the omniauth links" do
      render

      User::OMNIAUTH_PROVIDERS.each do |provider|
        href = send("user_#{provider}_omniauth_authorize_path")
        expect(page).to have_selector("a[href='#{href}']")

        label = page.find(".omniauth-btn--#{provider} .label")
        expect(label).
          to have_content(t("#{@t_prefix}.log_in_with.#{provider}"))
      end
    end
  end
end
