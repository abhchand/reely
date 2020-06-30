require "rails_helper"

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::ConfirmationsController, type: :controller do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

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

  describe "GET #show" do
    context "native auth is disabled" do
      before { stub_env("NATIVE_AUTH_ENABLED" => "false") }

      it "redirects to the root path with a flash message" do
        get :show

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("helpers.devise.auth_helper.error"))
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
end
