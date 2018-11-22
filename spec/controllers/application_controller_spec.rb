require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }

  describe "#ensure_authentication" do
    controller(ApplicationController) do
      before_action :ensure_authentication

      def index
        render plain: "test"
      end
    end

    context "user is authenticated" do
      before { session[:user_id] = user.id }

      it "renders the action" do
        get :index
        expect(response.body).to eq("test")
      end
    end

    context "user is not authenticated" do
      it "redirects to root_path with a :dest parameter" do
        get :index

        requested_path = ERB::Util.url_encode("/anonymous")
        expect(response).to redirect_to(root_path(dest: requested_path))
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

    before { session[:user_id] = user.id }

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
