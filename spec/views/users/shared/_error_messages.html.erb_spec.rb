require "rails_helper"

RSpec.describe "users/shared/_error_messages.html.erb", type: :view do
  let(:user) { build(:user) }

  it "renders the first error from each key" do
    user.errors.add(:email, :blank)
    user.errors.add(:email, :invalid)
    user.errors.add(:first_name, :blank)

    render_partial

    items = page.all("li")

    expect(items.count).to eq(2)
    expect(items[0]).to have_content(validation_error_for(:email, :blank))
    expect(items[1]).to have_content(validation_error_for(:first_name, :blank))
  end

  context "there are no errors" do
    it "renders nothing" do
      expect(user.valid?).to eq(true)

      render_partial

      expect(page).to_not have_selector(".auth__form-errors")
      expect(page.all("li").count).to eq(0)
    end
  end

  def render_partial(opts = {})
    render(
      partial: "users/shared/error_messages.html.erb",
      locals: { user: user }.merge(opts)
    )
  end
end
