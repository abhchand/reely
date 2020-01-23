require "rails_helper"

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::RegistrationsController, type: :controller do
  describe "POST #create" do
    let(:params) do
      {
        user: {
          first_name: "Nasir",
          last_name: "Jones",
          email: "nas@queensbridge.nyc",
          password: "b3sts0ngz#",
          password_confirmation: "b3sts0ngz#"
        }
      }
    end

    before { request.env["devise.mapping"] = Devise.mappings[:user] }

    it "audits the creation of the record" do
      post :create, params: params

      user = User.last
      audit = user.audits.last

      expect(audit.action).to eq("create")
      expect(audit.user).to be_nil
    end
  end
end
