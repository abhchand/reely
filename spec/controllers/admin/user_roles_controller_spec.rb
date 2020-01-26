require "rails_helper"

RSpec.describe Admin::UserRolesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in(admin)
    user.add_role(:manager)
  end

  describe "PATCH update" do
    let(:params) do
      {
        format: "json",
        id: user.synthetic_id,
        roles: %w[]
      }
    end

    it "calls the `admin_only` filter" do
      expect(controller).to receive(:admin_only).and_call_original
      patch :update, params: params
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        patch :update, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "user is not found" do
      before { params[:id] = "abcde" }

      it "responds as 404 not found" do
        patch :update, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq("error" => "User not found")
      end
    end

    context "admin does not have ability to edit user" do
      before do
        admin.remove_role(:admin)

        # Bypass the `admin_only` filter so we can test this action.
        expect(controller).to receive(:admin_only)
      end

      it "responds as 403 forbidden" do
        patch :update, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).
          to eq("error" => "Insufficent permission")
      end
    end

    it "updates the user roles" do
      params[:roles] = %w[director admin]

      patch :update, params: params

      expect(response.status).to eq(200)
      expect(response.body).to eq("{}")

      expect(user.reload.roles.pluck(:name)).to match_array(%w[director admin])
    end

    it "audits the addition and subtraction of the roles against the User" do
      params[:roles] = %w[director]

      patch :update, params: params

      audit = user.audits.last(2)

      # rubocop:disable Metrics/LineLength

      expect(audit[0].auditable).to eq(user)
      expect(audit[0].user).to eq(admin)
      expect(audit[0].action).to eq("update")
      expect(audit[0].audited_changes).to eq("audited_roles" => [nil, "director"])
      expect(audit[0].version).to eq(3)
      expect(audit[0].request_uuid).to_not be_nil
      expect(audit[0].remote_address).to_not be_nil

      expect(audit[1].auditable).to eq(user)
      expect(audit[1].user).to eq(admin)
      expect(audit[1].action).to eq("update")
      expect(audit[1].audited_changes).to eq("audited_roles" => ["manager", nil])
      expect(audit[1].version).to eq(4)
      expect(audit[1].request_uuid).to_not be_nil
      expect(audit[0].remote_address).to_not be_nil

      # rubocop:enable Metrics/LineLength
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
