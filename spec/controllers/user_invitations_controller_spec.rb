require "rails_helper"

RSpec.describe UserInvitationsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user_invitation) { create(:user_invitation) }

  before { sign_in(admin) }

  describe "DELETE #destroy" do
    let(:params) do
      {
        format: "json",
        id: user_invitation.id
      }
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        delete :destroy, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "user invitation is not found" do
      before { params[:id] = "abcde" }

      it "responds as 404 not found" do
        delete :destroy, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).
          to eq("error" => "User Invitation not found")
      end
    end

    context "admin does not have ability to edit user invitation" do
      before { admin.remove_role(:admin) }

      it "responds as 403 forbidden" do
        delete :destroy, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).
          to eq("error" => "Insufficent permission")
      end
    end

    it "deletes the user invitation and responds as success" do
      user_invitation

      expect do
        delete :destroy, params: params
      end.to change { UserInvitation.count }.by(-1)

      expect(response.status).to eq(200)
      expect(response.body).to eq("{}")
    end
  end
end
