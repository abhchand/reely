require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user, :admin) }

  describe "GET #index" do
    let(:params) do
      {
        format: "json"
      }
    end

    let!(:users) do
      [
        create(:user),
        create(:user),
        create(:user),
        user
      ]
    end

    before do
      sign_in(user)
      stub_ability(user).can(:read, :users)
    end

    context "user is not signed in" do
      before { sign_out(user) }

      it "responds with an error" do
        get :index, params: params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error"]).
          to eq(t("devise.failure.unauthenticated"))
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        get :index, params: params

        expect(response).to redirect_to(root_path)
      end
    end

    context "user does not have permissions to read  users" do
      before { stub_ability(user).cannot(:read, :users) }

      it "responds with an error" do
        get :index, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)["errors"]).
          to eq([{ "title" => "Insufficient Permissions", "status" => "403" }])
      end
    end

    describe "data" do
      it "responds with the data" do
        get :index, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)["data"]
        actual = data.map { |d| d["id"] }
        expected = users.map(&:synthetic_id).map(&:to_s)

        expect(actual).to match_array(expected)
      end

      describe "ordering" do
        it "returns a list of all users ordered by first name" do
          users[0].update(first_name: "III")
          users[1].update(first_name: "JJJ")
          users[2].update(first_name: "HHH")
          users[3].update(first_name: "ZZZ")

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)["data"]
          actual = data.map { |d| d["id"] }
          expected = [
            users[2],
            users[0],
            users[1],
            users[3]
          ].map(&:synthetic_id).map(&:to_s)

          expect(actual).to eq(expected)
        end

        it "falls back on last name and email for sorting" do
          users[0].update(first_name: "HHH", last_name: "CCC")
          users[1].update(first_name: "HHH", last_name: "BBB", email: "1@XY.Z")
          users[2].update(first_name: "HHH", last_name: "BBB", email: "2@XY.Z")
          users[3].update(first_name: "III")

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)["data"]
          actual = data.map { |d| d["id"] }
          expected = [
            users[1],
            users[2],
            users[0],
            users[3]
          ].map(&:synthetic_id).map(&:to_s)

          expect(actual).to eq(expected)
        end

        it "orders case insensitively" do
          users[0].update(first_name: "III")
          users[1].update(first_name: "jjj")
          users[2].update(first_name: "HhH")
          users[3].update(first_name: "zzz")

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)["data"]
          actual = data.map { |d| d["id"] }
          expected = [
            users[2],
            users[0],
            users[1],
            users[3]
          ].map(&:synthetic_id).map(&:to_s)

          expect(actual).to eq(expected)
        end
      end

      describe "scope" do
        it "only returns active users by default" do
          users[1].update(deactivated_at: Time.zone.now)

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)["data"]
          actual = data.map { |d| d["id"] }
          expected = [
            users[0],
            users[2],
            users[3]
          ].map(&:synthetic_id).map(&:to_s)

          expect(actual).to match_array(expected)
        end

        context "`active` param is specified as false" do
          before { params[:active] = false }

          it "only returns deactivated users" do
            users[1].update(deactivated_at: Time.zone.now)
            users[2].update(deactivated_at: Time.zone.now)

            get :index, params: params

            expect(response.status).to eq(200)

            data = JSON.parse(response.body)["data"]
            actual = data.map { |d| d["id"] }
            expected = [
              users[1],
              users[2]
            ].map(&:synthetic_id).map(&:to_s)

            expect(actual).to match_array(expected)
          end
        end

        context "`active` param is specified as true" do
          before { params[:active] = true }

          it "only returns active users" do
            users[1].update(deactivated_at: Time.zone.now)

            get :index, params: params

            expect(response.status).to eq(200)

            data = JSON.parse(response.body)["data"]
            actual = data.map { |d| d["id"] }
            expected = [
              users[0],
              users[2],
              users[3]
            ].map(&:synthetic_id).map(&:to_s)

            expect(actual).to match_array(expected)
          end
        end
      end

      it "filters by the search string" do
        users[0].update(first_name: "Georgia")
        users[1].update(first_name: "Virginia")
        users[2].update(first_name: "California")
        users[3].update(first_name: "Florida")

        params[:search] = "nia"

        get :index, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)["data"]
        actual = data.map { |d| d["id"] }
        expected = [users[2], users[1]].map(&:synthetic_id).map(&:to_s)

        expect(actual).to eq(expected)
      end
    end

    describe "meta" do
      let(:meta) { JSON.parse(response.body)["meta"] }

      it "includes the totalCount count in the meta information" do
        get :index, params: params

        expect(meta["totalCount"]).to eq(User.count)
      end

      context "a search string is present" do
        it "the totalCount is count after searching records" do
          users[0].update(first_name: "Georgia")
          users[1].update(first_name: "Virginia")
          users[2].update(first_name: "California")
          users[3].update(first_name: "Florida")

          params[:search] = "nia"

          get :index, params: params

          expect(meta["totalCount"]).to eq(2)
        end
      end
    end

    describe "relationships" do
      let(:relationships) do
        JSON.parse(response.body)["data"][0]["relationships"]
      end

      it "responds with no relations" do
        get :index, params: params

        expect(relationships).to be_nil
      end
    end

    describe "pagination" do
      before do
        stub_const("Api::Response::PaginationLinksService::PAGE_SIZE", 2)

        # Creates 3 pages of 2 records each
        # page 1: users[0], users[1]
        # page 2: users[2], users[3]
        # page 3: users[4]
        users[0].update(first_name: "AAA")
        users[1].update(first_name: "BBB")
        users[2].update(first_name: "CCC")
        users[3].update(first_name: "DDD")
        users << create(:user, first_name: "EEE")

        params[:per_page] = 2
        params[:page] = 2
      end

      it "paginates the data based on the params" do
        get :index, params: params

        data = JSON.parse(response.body)["data"]
        actual = data.map { |d| d["id"] }
        expected = [users[2], users[3]].map(&:synthetic_id).map(&:to_s)

        expect(actual).to eq(expected)
      end

      it "responds with the pagination links" do
        get :index, params: params

        links = JSON.parse(response.body)["links"]

        expect(links["self"]).
          to eq(api_v1_users_url(page: 2, per_page: 2))
      end
    end
  end

  describe "GET #show" do
    let(:params) do
      {
        format: "json",
        id: user.synthetic_id
      }
    end

    before do
      sign_in(user)
      stub_ability(user).can(:read, User)
    end

    context "user is not signed in" do
      before { sign_out(user) }

      it "responds with an error" do
        get :show, params: params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error"]).
          to eq(t("devise.failure.unauthenticated"))
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        get :show, params: params

        expect(response).to redirect_to(root_path)
      end
    end

    context "user does not have permissions to read User" do
      before { stub_ability(user).cannot(:read, User) }

      it "responds with an error" do
        get :show, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)["errors"]).
          to eq([{ "title" => "Insufficient Permissions", "status" => "403" }])
      end
    end

    describe "record is not found" do
      before { params[:id] = -1 }

      it "responds with an error" do
        get :show, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["errors"]).
          to eq(
            [
              {
                "title" => "Record Not Found",
                "description" => "Couldn't find User with 'id'=-1",
                "status" => "404"
              }
            ]
          )
      end
    end

    describe "data" do
      it "responds with the data" do
        get :show, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)["data"]

        actual = data["id"]
        expected = user.synthetic_id.to_s

        expect(actual).to eq(expected)
      end
    end

    describe "relationships" do
      let(:relationships) do
        JSON.parse(response.body)["data"]["relationships"]
      end

      it "responds with no relationships" do
        get :show, params: params
        expect(relationships).to be_nil
      end
    end
  end

  describe "PATCH #update" do
    let(:user) do
      create(:user, :admin, first_name: "Dante", last_name: "Basco")
    end

    let(:params) do
      {
        format: "json",
        id: user.synthetic_id,
        user: {
          first_name: "Mae",
          last_name: "Whitman"
        }
      }
    end

    before do
      sign_in(user)
      stub_ability(user).can(:write, User)
    end

    context "user is not signed in" do
      before { sign_out(user) }

      it "responds with an error" do
        patch :update, params: params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error"]).
          to eq(t("devise.failure.unauthenticated"))
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        patch :update, params: params

        expect(response).to redirect_to(root_path)
      end
    end

    context "user does not have permissions to write the user" do
      before { stub_ability(user).cannot(:write, User) }

      it "responds with an error" do
        patch :update, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)["errors"]).
          to eq([{ "title" => "Insufficient Permissions", "status" => "403" }])
      end
    end

    describe "User record is not found" do
      before { params[:id] = -1 }

      it "responds with an error" do
        patch :update, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["errors"]).
          to eq(
            [
              {
                "title" => "Record Not Found",
                "description" => "Couldn't find User with 'id'=-1",
                "status" => "404"
              }
            ]
          )
      end
    end

    describe "updating the user" do
      context "updating first or last name" do
        it "updates the user" do
          expect do
            patch :update, params: params
          end.to(
            change { user.reload.first_name }.from("Dante").to("Mae")
          )

          expect(user.last_name).to eq("Whitman")
        end

        it "audits the update" do
          params[:user][:first_name] = "Mae"
          params[:user][:last_name] = "Whitman"

          expect do
            post :update, params: params
          end.to(change { Audited::Audit.count }.by(1))

          audit = Audited::Audit.last

          expect(audit.auditable).to eq(user)
          expect(audit.user).to eq(user)
          expect(audit.action).to eq("update")
          expect(audit.audited_changes).
            to eq(
              "first_name" => %w[Dante Mae],
              "last_name" => %w[Basco Whitman]
            )
          expect(audit.version).to eq(3)
          expect(audit.request_uuid).to_not be_nil
          expect(audit.remote_address).to_not be_nil
        end

        it "can not remove the first or last names" do
          params[:user][:first_name] = nil
          params[:user][:last_name] = nil

          expect do
            patch :update, params: params
          end.to_not(change { user.reload.first_name })
        end
      end
    end

    describe "data" do
      it "responds with the data" do
        params[:user][:first_name] = "Mae"
        params[:user][:last_name] = "Whitman"

        patch :update, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)["data"]

        actual = data["id"]
        expected = user.synthetic_id.to_s

        expect(actual).to eq(expected)
      end
    end
  end
end
