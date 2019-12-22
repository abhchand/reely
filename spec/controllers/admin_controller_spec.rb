require "rails_helper"

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user, :admin) }

  before { sign_in(user) }

  describe "#admin_only" do
    controller(AdminController) do
      before_action :admin_only

      def index
        respond_to do |format|
          format.json { render json: { msg: "success-json" }, status: 200 }
          format.html { render plain: "success-html" }
        end
      end
    end

    let(:params) { {} }

    context "format html" do
      before { params[:format] = "html" }

      it "should render the action" do
        get :index, params: params

        expect(response.body).to eq("success-html")
      end

      context "user is not an admin" do
        before { user.remove_role(:admin) }

        it "should redirect to root_path" do
          get :index, params: params

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "format json" do
      before { params[:format] = "json" }

      it "should render the action" do
        get :index, params: params

        expect(JSON.parse(response.body)).to eq("msg" => "success-json")
        expect(response.status).to eq(200)
      end

      context "user is not an admin" do
        before { user.remove_role(:admin) }

        it "should return a 401 JSON response" do
          get :index, params: params

          expect(JSON.parse(response.body)).to eq("error" => "Access Denied")
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe "GET index" do
    it "calls the `admin_only` filter" do
      expect(controller).to receive(:admin_only).and_call_original
      get :index
    end

    it "should render the template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
