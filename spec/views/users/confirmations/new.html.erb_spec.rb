require "rails_helper"

RSpec.describe "users/confirmations/new.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    # rubocop:disable LineLength
    stub_template "layouts/_flash.html.erb" => "_stubbed_flash"
    stub_template "users/shared/_error_messages.html.erb" => "_stubbed_error_messages"
    stub_template "users/shared/_native_links.html.erb" => "_stubbed_users_native_links"
    # rubocop:enable LineLength

    assign(:user, user)

    @t_prefix = "users.confirmations.new"
  end

  subject { rendered }

  it "renders the auth form" do
    render

    # General

    is_expected.to have_selector(".auth__logo svg")
    expect(page.find(".auth__heading")).
      to have_content(t("#{@t_prefix}.heading"))

    expect(page.find(".auth__form")["action"]).to eq(user_confirmation_path)

    # Partials

    is_expected.to have_content("_stubbed_flash")
    is_expected.to have_content("_stubbed_error_messages")
    is_expected.to have_content("_stubbed_users_native_links")

    # Email

    email = page.find("#user_email")
    expect(email["value"]).to eq(user.email)
    expect(email["autocomplete"]).to eq("email")
    expect(email["autofocus"]).to eq("autofocus")
    expect(email["type"]).to eq("email")
    expect(email["placeholder"]).to eq(User.human_attribute_name(:email))

    expect(page.find("label[for='user_email']")).
      to have_content(User.human_attribute_name(:email))

    # Submit

    submit = page.find(".auth__form-input--submit input")
    expect(submit["type"]).to eq("submit")
    expect(submit["value"]).to eq(t("#{@t_prefix}.form.submit"))
    expect(submit["data-disable-with"]).to eq(t("form.disable_with"))
  end

  context "user has an unconfirmed email" do
    before { user.update!(unconfirmed_email: "abcde@foo.com") }

    it "populates the unconfirmed email as the input field value" do
      render

      email = page.find("#user_email")
      expect(email["value"]).to eq("abcde@foo.com")
    end
  end
end
