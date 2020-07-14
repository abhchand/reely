require "rails_helper"

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::RegistrationsController, type: :controller do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET #cancel" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        get :cancel

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

  describe "GET #new" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

  describe "GET #edit" do
    context "user is signed in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "redirects to the account_profile_index_path" do
        get :edit

        expect(response).to redirect_to(account_profile_index_path)
      end
    end

    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        get :edit

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

  describe "PATCH #update" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        patch :update

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

  describe "DELETE #destroy" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        delete :destroy

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

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

    context "a UserInvitation record exists with this email" do
      let!(:invitation) do
        create(:user_invitation, email: params[:user][:email])
      end

      it "marks the invitation as complete" do
        expect(invitation.invitee).to be_nil

        post :create, params: params

        invitation.reload
        expect(invitation.invitee.email).to eq(params[:user][:email])
      end

      it "notifies the inviter of completion" do
        # mailer_queue changes by 2 since we send confirmation email as well
        expect do
          post :create, params: params
        end.to(change { mailer_queue.count }.by(2))

        email = mailer_queue.last
        expect(email[:klass]).to eq(UserInvitationMailer)
        expect(email[:method]).to eq(:notify_inviter_of_completion)
        expect(email[:args][:user_invitation_id]).to eq(invitation.id)
      end

      context "user record failed to create" do
        # Should cause failure when calling `resource.save` in
        # `registrations#create` in Devise
        before { expect_any_instance_of(User).to receive(:save) { false } }

        it "does not update the invitation" do
          expect do
            post :create, params: params
          end.to_not(change { User.count })

          expect(invitation.reload.invitee).to be_nil
        end
      end
    end

    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        post :create

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end
end
