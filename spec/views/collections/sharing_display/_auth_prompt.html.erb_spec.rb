require "rails_helper"

RSpec.describe "collections/sharing_display/_auth_prompt.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    assign(:user, @user)
    @t_prefix = "collections.sharing_display.auth_prompt"
  end

  context "user is blank" do
    let(:user) { nil }

    it "renders nothing" do
      render
      expect(rendered).to eq("")
    end
  end

  context "user is present" do
    it "renders the registration link, log in link, and close button" do
      render

      expect(page).to have_link(
        t("#{@t_prefix}.register"),
        href: new_user_registration_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.log_in"),
        href: new_user_session_path
      )
      expect(page).to have_selector("button.close")
    end
  end
end
