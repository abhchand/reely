require "rails_helper"

RSpec.describe SiteController, type: :controller do
  describe "#index" do
    let(:user) { create(:user) }

    context "user is signed in" do
      before do
        session[:user_id] = user.id
        get :index
      end

      it "redirects to the photos_path" do
        expect(response).to redirect_to(photos_path)
      end
    end

    context "user is not signed in" do
      before { get :index }

      it "renders the page" do
        expect(response.status).to eq(200)
        expect(response).to render_template("site/index")
      end
    end

    context "dest param is present" do
      it "assigns @dest" do
        get :index, params: { dest: "foo" }
        expect(assigns(:dest)).to eq("foo")
      end
    end
  end
end
