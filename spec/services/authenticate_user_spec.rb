require "rails_helper"

RSpec.describe AuthenticateUser, type: :service do
  describe "#call" do
    let(:user) { create(:user, password: password) }
    let(:password) { "kingK0ng" }

    let(:params) do
      {
        email: user.email,
        password: password
      }
    end

    before { @t_prefix = "sessions.create.authenticate" }

    it "fails when the email is missing" do
      response = call(email: "")
      expect(response.success?).to be_falsey
      expect(response.error_message).to eq(t("#{@t_prefix}.blank_email"))
    end

    it "fails when the password is missing" do
      response = call(password: "")
      expect(response.success?).to be_falsey
      expect(response.error_message).to eq(t("#{@t_prefix}.blank_password"))
    end

    it "fails when the email is wrong" do
      email = "foo@example.com"
      response = call(email: email)
      expect(response.success?).to be_falsey
      expect(response.error_message).to eq(t("#{@t_prefix}.invalid_login"))
    end

    it "fails when the password is wrong" do
      response = call(password: "foo")
      expect(response.success?).to be_falsey
      expect(response.error_message).to eq(t("#{@t_prefix}.invalid_login"))
    end

    it "succeeds when all validations pass" do
      response = call
      expect(response.success?).to be_truthy
      expect(response.error_message).to be_nil
      expect(response.user).to eq(user)
    end
  end

  def call(new_params = {})
    AuthenticateUser.call(params: params.merge(new_params))
  end
end
