require "rails_helper"

RSpec.describe "site/index.html.erb", type: :view do
  before { @t_prefix = "site.index" }

  subject { rendered }

  it "displays the logo" do
    render
    is_expected.to have_selector(".site-index-logo svg")
  end

  it "displays the email and password input fields" do
    render

    field = page.find("input[name='session[email]']")
    expect(field[:placeholder]).to eq(User.human_attribute_name(:email))

    field = page.find("input[name='session[password]']")
    expect(field[:placeholder]).to eq(User.human_attribute_name(:password))
  end

  context "@dest parameter present" do
    before { assign(:dest, "foo") }

    it "sets the hidden :dest field" do
      render

      field = page.find("input#dest", visible: false)
      expect(field.value).to eq("foo")
    end
  end

  it "displays the submit button" do
    render

    is_expected.
      to have_selector(".site-index-auth-form__container input[name='log-in']")
  end
end
