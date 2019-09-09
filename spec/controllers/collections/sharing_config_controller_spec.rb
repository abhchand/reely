require "rails_helper"

RSpec.describe Collections::SharingConfigController, type: :controller do
  let(:user) { create(:user) }
  let(:collection) { create(:collection, owner: user) }
  let(:sharing_config) { Collections::SharingConfigService.new(collection) }
  let(:xhr) { true }

  before { sign_in(user) }

  describe "GET #show" do
    let(:params) { { format: "json", collection_id: collection.synthetic_id } }

    context "user is not logged in" do
      before { sign_out(user) }

      it "returns a 401 JSON response" do
        get :show, params: params, xhr: xhr

        expect(response.status).to eq(401)
        expect(parsed_response).
          to eq("error" => t("devise.failure.unauthenticated"))
      end
    end

    context "request is not xhr" do
      let(:xhr) { false }

      it "redirects to the root_path" do
        get :show, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        get :show, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "returns a 400 JSON response" do
        get :show, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    context "collection does not belong to the logged in user" do
      before { collection.update!(owner: create(:user)) }

      it "returns a 400 JSON response" do
        get :show, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    it "returns the sharing config for the collection" do
      get :show, params: params, xhr: xhr

      expect(response.status).to eq(200)
      expect(parsed_response).to eq(sharing_config_json)
    end
  end

  describe "POST #update" do
    let(:params) do
      {
        format: "json",
        collection_id: collection.synthetic_id,
        link_sharing_enabled: true
      }
    end

    before { collection }

    context "user is not logged in" do
      before { sign_out(user) }

      it "returns a 401 JSON response" do
        post :update, params: params, xhr: xhr

        expect(response.status).to eq(401)
        expect(parsed_response).
          to eq("error" => t("devise.failure.unauthenticated"))
      end
    end

    context "request is not xhr" do
      let(:xhr) { false }

      it "redirects to the root_path" do
        post :update, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        post :update, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "returns a 400 JSON response" do
        post :update, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    context "collection does not belong to the logged in user" do
      before { collection.update!(owner: create(:user)) }

      it "returns a 400 JSON response" do
        post :update, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    context "params have an unpermitted key" do
      before { params[:foo] = "bar" }

      it "ignores the unpermitted keys" do
        post :update, params: params, xhr: xhr

        collection.reload

        expect(response.status).to eq(200)
        expect(parsed_response).to eq(sharing_config_json)

        expect(collection.sharing_config["foo"]).to be_nil
      end
    end

    it "updates the sharing_config" do
      post :update, params: params, xhr: xhr

      collection.reload

      expect(response.status).to eq(200)
      expect(parsed_response).to eq(sharing_config_json)

      expect(collection.sharing_config["link_sharing_enabled"]).to eq(true)
    end
  end

  describe "POST #renew_link" do
    let(:params) do
      {
        format: "json",
        collection_id: collection.synthetic_id
      }
    end

    before { collection }

    context "user is not logged in" do
      before { sign_out(user) }

      it "returns a 401 JSON response" do
        post :renew_link, params: params, xhr: xhr

        expect(response.status).to eq(401)
        expect(parsed_response).
          to eq("error" => t("devise.failure.unauthenticated"))
      end
    end

    context "request is not xhr" do
      let(:xhr) { false }

      it "redirects to the root_path" do
        post :renew_link, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to the root_path" do
        post :renew_link, params: params, xhr: xhr

        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "returns a 400 JSON response" do
        post :renew_link, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    context "collection does not belong to the logged in user" do
      before { collection.update!(owner: create(:user)) }

      it "returns a 400 JSON response" do
        post :renew_link, params: params, xhr: xhr

        expect(response.status).to eq(400)
        expect(parsed_response).to eq({})
      end
    end

    it "renews the collection share_id" do
      expect do
        post :renew_link, params: params, xhr: xhr
      end.to(change { collection.reload.share_id })

      expect(response.status).to eq(200)
      expect(parsed_response).to eq(sharing_config_json)
    end
  end

  def parsed_response
    JSON.parse(response.body)
  end

  def sharing_config_json
    sharing_config.as_json.deep_stringify_keys
  end
end
