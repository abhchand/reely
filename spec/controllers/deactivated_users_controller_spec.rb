require "rails_helper"

RSpec.describe DeactivatedUsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user, :deactivated) }

  before { sign_in(admin) }

  describe "GET index" do
    before do
      sign_out(admin)
      sign_in(user)
    end

    it "renders the action" do
      get :index

      expect(response).to render_template(:index)
    end

    context "user is not deactivated" do
      let(:user) { create(:user) }

      it "redirects to the root path" do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:params) do
      {
        format: "json",
        id: user.synthetic_id
      }
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        delete :destroy, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "user is not found" do
      before { params[:id] = "abcde" }

      it "responds as 404 not found" do
        delete :destroy, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq("error" => "User not found")
      end
    end

    context "admin does not have ability to edit user" do
      before { admin.remove_role(:admin) }

      it "responds as 403 forbidden" do
        delete :destroy, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).
          to eq("error" => "Insufficent permission")
      end
    end

    it "activates the user and responds as success" do
      expect do
        delete :destroy, params: params
      end.to change { user.reload.deactivated? }.from(true).to(false)

      expect(response.status).to eq(200)
      expect(response.body).to eq("{}")
    end

    it "audits the deactivation of the record" do
      delete :destroy, params: params

      audit = user.audits.last

      expect(audit.action).to eq("update")
      expect(audit.audited_changes.keys).to include("deactivated_at")
      expect(audit.user).to eq(admin)
    end

    context "user is already activated" do
      before { user.update!(deactivated_at: nil) }

      it "does not update the user again, but still responds as success" do
        delete :destroy, params: params

        expect(user.reload.deactivated_at).to be_nil
        expect(response.status).to eq(200)
        expect(response.body).to eq("{}")
      end
    end
  end
end
