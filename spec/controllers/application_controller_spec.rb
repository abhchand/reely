require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }

  describe "#authenticate_user!" do
    controller(ApplicationController) do
      before_action :authenticate_user!

      def index
        render plain: "test"
      end
    end

    context "user is authenticated" do
      before { sign_in(user) }

      it "renders the action" do
        get :index
        expect(response.body).to eq("test")
      end
    end

    context "user is not authenticated" do
      it "redirects to new_user_session_path" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#ensure_xhr_only" do
    controller(ApplicationController) do
      before_action :ensure_xhr_only

      def index
        render plain: "test"
      end
    end

    before { sign_in(user) }

    context "request is xhr" do
      it "renders the action" do
        get :index, xhr: true
        expect(response.body).to eq("test")
      end
    end

    context "request is not xhr" do
      it "redirects to root_path" do
        get :index, xhr: false
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
