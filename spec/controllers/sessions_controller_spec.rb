require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before do
    # Set a referrer explicitly since the controller requires it to
    # redirect_to(:back)
    @request.env["HTTP_REFERER"] = root_path
  end

  describe "POST #create" do
    let(:user) { create(:user, password: password) }
    let(:password) { "kingK0ng" }

    let(:params) do
      {
        session: {
          email: user.email,
          password: password
        }
      }
    end

    context "user authentication is successful" do
      it "sets the session id" do
        post :create, params
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the photos_path" do
        post :create, params
        expect(response).to redirect_to(photos_path)
      end

      context "a dest param is set" do
        it "redirects to the specified destionation" do
          raw_dest = CGI.escape(collections_path)
          post :create, params.merge(dest: raw_dest)

          expect(response).to redirect_to(collections_path)
        end
      end
    end

    context "user authentication is unsuccesful" do
      before { params[:session][:password] = "foo" }

      it "sets the flash message" do
        post :create, params
        expect(flash[:error]).
          to eq(t("sessions.create.authenticate.invalid_login"))
      end

      it "redirects to the root path" do
        post :create, params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #destroy" do
    let(:user) { create(:user) }

    before { session[:user_id] = user.id }

    it "clears the session" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
