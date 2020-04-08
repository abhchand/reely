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

  describe "#check_if_deactivated" do
    controller(ApplicationController) do
      before_action :check_if_deactivated

      def index
        render plain: "test"
      end
    end

    let(:user) { create(:user, :deactivated) }

    before { sign_in(user) }

    it "redirects to deactivated_users_path" do
      get :index
      expect(response).to redirect_to(deactivated_users_path)
    end

    context "request is json format" do
      it "renders the action" do
        get :index, params: { format: "json" }
        expect(JSON.parse(response.body)).
          to eq("error" => "User is deactivated")
      end
    end

    context "user is not signed in" do
      controller(ApplicationController) do
        skip_before_action :authenticate_user!
        before_action :check_if_deactivated

        def index
          render plain: "test"
        end
      end

      before { sign_out(user) }

      it "renders the action" do
        get :index
        expect(response.body).to eq("test")
      end
    end

    context "user is not deactivated" do
      before { user.update!(deactivated_at: nil) }

      it "renders the action" do
        get :index
        expect(response.body).to eq("test")
      end
    end
  end

  describe "#ensure_json_request" do
    controller(ApplicationController) do
      before_action :ensure_json_request

      def index
        render json: { "message" => "test" }
      end
    end

    before { sign_in(user) }

    context "request is json format" do
      it "renders the action" do
        get :index, params: { format: "json" }
        expect(JSON.parse(response.body)).to eq("message" => "test")
      end
    end

    context "request is not json format" do
      it "redirects to root_path" do
        get :index, params: { format: "html" }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
