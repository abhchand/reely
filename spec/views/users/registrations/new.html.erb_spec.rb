require "rails_helper"

RSpec.describe "users/registrations/new.html.erb", type: :view do
  let(:user) { User.new }

  before do
    # rubocop:disable LineLength
    stub_template "layouts/_flash.html.erb" => "_stubbed_flash"
    stub_template "users/shared/_error_messages.html.erb" => "_stubbed_error_messages"
    stub_template "users/shared/_native_links.html.erb" => "_stubbed_users_native_links"
    stub_template "users/shared/_omniauth_links.html.erb" => "_stubbed_users_omniauth_links"
    # rubocop:enable LineLength

    assign(:user, user)

    @t_prefix = "users.registrations.new"
  end

  subject { rendered }

  it "renders the auth form" do
    render

    # General

    is_expected.to have_selector(".auth__logo svg")
    expect(page.find(".auth__heading")).
      to have_content(t("#{@t_prefix}.heading"))

    expect(page.find(".auth__form")["action"]).to eq(user_registration_path)
    expect(page.find(".auth__action-conditional")).
      to have_content(t("#{@t_prefix}.or"))

    # Partials

    is_expected.to have_content("_stubbed_flash")
    is_expected.to have_content("_stubbed_error_messages")
    is_expected.to have_content("_stubbed_users_native_links")
    is_expected.to have_content("_stubbed_users_omniauth_links")

    # First Name

    first_name = page.find("#user_first_name")
    expect(first_name["autofocus"]).to eq("autofocus")
    expect(first_name["autocomplete"]).to eq("given-name")
    expect(first_name["type"]).to eq("text")
    expect(first_name["placeholder"]).
      to eq(User.human_attribute_name(:first_name))

    expect(page.find("label[for='user_first_name']")).
      to have_content(User.human_attribute_name(:first_name))

    # Last Name

    last_name = page.find("#user_last_name")
    expect(last_name["autocomplete"]).to eq("family-name")
    expect(last_name["type"]).to eq("text")
    expect(last_name["placeholder"]).
      to eq(User.human_attribute_name(:last_name))

    expect(page.find("label[for='user_last_name']")).
      to have_content(User.human_attribute_name(:last_name))

    # Email

    email = page.find("#user_email")
    expect(email["autocomplete"]).to eq("email")
    expect(email["type"]).to eq("email")
    expect(email["placeholder"]).to eq(User.human_attribute_name(:email))

    expect(page.find("label[for='user_email']")).
      to have_content(User.human_attribute_name(:email))

    # Password

    password = page.find("#user_password")
    expect(password["autocomplete"]).to eq("new-password")
    expect(password["type"]).to eq("password")
    expect(password["placeholder"]).to eq(User.human_attribute_name(:password))

    expect(page.find("label[for='user_password']")).
      to have_content(User.human_attribute_name(:password))

    # Password Confirmation

    password_confirmation = page.find("#user_password_confirmation")
    expect(password_confirmation["autocomplete"]).to eq("off")
    expect(password_confirmation["type"]).to eq("password")
    expect(password_confirmation["placeholder"]).
      to eq(User.human_attribute_name(:password_confirmation))

    expect(page.find("label[for='user_password_confirmation']")).
      to have_content(User.human_attribute_name(:password_confirmation))

    # Submit

    submit = page.find(".auth__form-input--submit input")
    expect(submit["type"]).to eq("submit")
    expect(submit["value"]).to eq(t("#{@t_prefix}.form.submit"))
    expect(submit["data-disable-with"]).to eq(t("form.disable_with"))
  end
end
