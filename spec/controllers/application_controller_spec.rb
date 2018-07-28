require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#ensure_xhr_only" do
    let(:user) { create(:user) }

    controller(ApplicationController) do
      before_action :ensure_xhr_only

      def index
        render plain: "test"
      end
    end

    before { session[:user_id] = user.id }

    context "request is xhr" do
      before { allow(controller.request).to receive(:xhr?) { true } }

      it "renders the action" do
        get :index
        expect(response.body).to eq("test")
      end
    end

    context "request is not xhr" do
      before { allow(controller.request).to receive(:xhr?) { false } }

      it "redirects to root_path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
