require "rails_helper"

RSpec.describe UserInvitationsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user_invitation) { create(:user_invitation) }

  before { sign_in(admin) }

  describe "POST #create" do
    let(:params) do
      {
        format: "json",
        user_invitation: {
          email: "xyz@foo.com"
        }
      }
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        post :create, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "admin does not have ability to manage invitations" do
      before { admin.remove_role(:admin) }

      it "responds as 403 forbidden" do
        post :create, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).
          to eq("error" => "Insufficent permissions")
      end
    end

    context "error in creating the user invitation" do
      before do
        # Try creating a user invitation with a duplicate email
        params[:user_invitation][:email] = user_invitation.email
      end

      it "does not create the user invitation and responds as failure" do
        expect do
          post :create, params: params
        end.to_not(change { UserInvitation.count })

        msg = I18n.t(
          "activerecord.errors.models.user_invitation.attributes.email."\
            "already_invited"
        )

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).to eq("error" => msg)
      end

      it "does not deliver any email" do
        expect do
          post :create, params: params
        end.to_not(change { mailer_queue.count })
      end
    end

    it "creates the user invitation and responds as success" do
      expect do
        post :create, params: params
      end.to change { UserInvitation.count }.by(1)

      user_invitation = UserInvitation.last
      expect(user_invitation.email).to eq(params[:user_invitation][:email])

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(user_invitation.as_json)
    end

    it "emails an invitation to the invited user" do
      expect do
        post :create, params: params
      end.to change { mailer_queue.count }.by(1)

      email = mailer_queue.last
      expect(mailer_queue.count).to eq(1)
      expect(email[:klass]).to eq(UserInvitationMailer)
      expect(email[:method]).to eq(:invite)
      expect(email[:args][:user_invitation_id]).to eq(UserInvitation.last.id)
    end

    it "audits the creation of the record" do
      post :create, params: params

      user_invitation = UserInvitation.last
      audit = user_invitation.audits.last

      expect(audit.action).to eq("create")
      expect(audit.user).to eq(admin)
    end
  end

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
          to eq("error" => "Insufficent permissions")
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

    it "audits the deletion of the record" do
      delete :destroy, params: params

      audit = user_invitation.audits.last

      expect(audit.action).to eq("destroy")
      expect(audit.user).to eq(admin)
    end
  end
end
