require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before { sign_in(admin) }

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

    it "deactivates the user and responds as success" do
      expect do
        delete :destroy, params: params
      end.to change { user.reload.deactivated? }.from(false).to(true)

      expect(response.status).to eq(200)
      expect(response.body).to eq("{}")
    end

    context "user is already deactivated" do
      let(:now) { Time.zone.now }

      before { user.update!(deactivated_at: now) }

      it "does not update the user again, but still responds as success" do
        delete :destroy, params: params

        expect(user.reload.deactivated_at).to eq(now)
        expect(response.status).to eq(200)
        expect(response.body).to eq("{}")
      end
    end
  end
end
