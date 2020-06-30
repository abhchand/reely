require "rails_helper"

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::SessionsController, type: :controller do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET #new" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "should not redirect away" do
        get :new

        expect(response).to_not redirect_to(root_path)
        expect(flash[:error]).to be_nil
      end
    end
  end

  describe "POST #create" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        post :create

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
      end
    end
  end

  describe "DELETE #destroy" do
    context "user is signed in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "redirects to the root_path" do
        get :destroy
        expect(response).to redirect_to(root_path)
      end

      context "user is deactivated" do
        before { user.update!(deactivated_at: Time.zone.now) }

        it "does not redirect to the deactivated page, causing infinite loop" do
          get :destroy
          expect(response).to_not redirect_to(deactivated_users_path)
        end
      end
    end

    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "should not redirect away" do
        delete :destroy

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to be_nil
      end
    end
  end
end
