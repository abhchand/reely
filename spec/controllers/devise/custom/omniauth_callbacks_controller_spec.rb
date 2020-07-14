require "rails_helper"

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::OmniauthCallbacksController, type: :controller do
  describe "GET #google_oauth2" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        uid: "some-fake-uid",
        info: {
          first_name: "Srinivasa",
          last_name: "Ramanujan",
          email: "srini@math.com",
          image: fixture_path_for("images/chennai.jpg")
        }
      )
    end

    before do
      request.env["omniauth.auth"] = auth
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "signs in and redirects the user" do
      expect { get :google_oauth2 }.to(change { User.count }.by(1))

      user = User.last

      expect(controller.current_user).to eq(user)
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to be_nil
    end

    it "audits the creation of the record" do
      get :google_oauth2

      user = User.last
      audit = user.audits.last

      expect(audit.action).to eq("create")
      expect(audit.user).to be_nil
    end

    context "error in creating" do
      before { auth[:info][:email] = "bad-email" }

      it "sets a flash message and redirects to the login page" do
        expect { get :google_oauth2 }.to_not(change { User.count })

        expect(controller.current_user).to be_nil
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:error]).to eq(t("generic_error"))
      end
    end

    context "a UserInvitation record exists with this email" do
      let!(:invitation) do
        create(:user_invitation, email: auth[:info][:email])
      end

      it "marks the invitation as complete" do
        expect(invitation.invitee).to be_nil

        get :google_oauth2

        invitation.reload
        expect(invitation.invitee.email).to eq(auth[:info][:email])
      end

      context "user record failed to create" do
        before { auth[:uid] = nil }

        it "does not update the invitation" do
          expect do
            get :google_oauth2
          end.to_not(change { User.count })

          expect(invitation.reload.invitee).to be_nil
        end
      end
    end
  end
end
