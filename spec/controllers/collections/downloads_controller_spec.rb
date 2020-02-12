require "rails_helper"

RSpec.describe Collections::DownloadsController, type: :controller do
  let(:user) { create(:user) }

  let(:collection) { create_collection_with_photos(owner: user) }
  let(:service) { Collections::SharingConfigService.new(collection) }

  let(:decrypted_id) { SecureRandom.hex }
  let(:encrypted_id) { controller.send(:verifier).generate(decrypted_id) }

  let(:download_dir) do
    Rails.configuration.x.default_download_dir.join(decrypted_id)
  end

  before do
    session[:user_id] = user.id
    @t_prefix = "collections.downloads"

    service.update(link_sharing_enabled: true)
  end

  describe "GET #show" do
    let(:params) do
      {
        collection_id: collection.share_id,
        id: encrypted_id
      }
    end

    context "user is not authenticated" do
      before { session[:user_id] = nil }

      it "still calls the controller action" do
        get :show, params: params

        # It's going to hit the action but it won't find the file, so it will
        # set a flash error. Just test this as "proof" that we hit the
        # controller action
        expect(flash[:error]).to eq(t("#{@t_prefix}.not_found"))
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "redirects to root_path" do
        get :show, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not shared" do
      before { service.update(link_sharing_enabled: false) }

      it "redirects to root_path" do
        get :show, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "encrypted id is invalid" do
      before { params[:id] = "something-fake" }

      it "sets a flash error and redirects to the root_path" do
        get :show, params: params

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("#{@t_prefix}.not_found"))
      end
    end

    context "download is missing" do
      it "sets a flash error and redirects to the root_path" do
        get :show, params: params

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t("#{@t_prefix}.not_found"))
      end
    end

    it "returns the download" do
      create_download_file(fixture: "images/chennai.jpg")
      create_download_file(fixture: "images/atlanta.jpg")
      create_download_bundle(name: "file.zip")

      filepath = download_dir.join("file.zip")
      mime_type = Collections::DownloadsController::ZIP_FILE_MIME_TYPE

      expect(controller).to(
        receive(:send_file).
        with(filepath, type: mime_type).
        and_call_original
      )

      get :show, params: params
    end
  end

  describe "POST #create" do
    let(:params) do
      {
        format: "json",
        collection_id: collection.share_id
      }
    end

    context "user is not authenticated" do
      before { session[:user_id] = nil }

      it "still calls the controller action" do
        expect do
          post :create, params: params
        end.to(change { BundleFilesJob.jobs.size }.by(1))
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        post :create, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "returns a 400 Error JSON response" do
        post :create, params: params

        expect(JSON.parse(response.body)).to eq({})
        expect(response.code).to eq("400")
      end
    end

    context "collection is not shared" do
      before { service.update(link_sharing_enabled: false) }

      it "returns a 400 Error JSON response" do
        post :create, params: params

        expect(JSON.parse(response.body)).to eq({})
        expect(response.code).to eq("400")
      end
    end

    context "collection has no photos" do
      before { collection.photos.destroy_all }

      it "responds with a JSON error" do
        post :create, params: params
        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).to eq("error" => "Empty collection")
      end
    end

    it "enqueues the `BundleFilesJob`" do
      # Minor side effect: This also sets the `jid` of the job since Sidekiq
      # uses `SecureRandom.hex` for that.
      allow(SecureRandom).to receive(:hex) { "abcdefgh" }

      expect do
        post :create, params: params
      end.to(change { BundleFilesJob.jobs.size }.by(1))

      job = BundleFilesJob.jobs.last
      expect(job["class"]).to eq("BundleFilesJob")
      expect(job["args"]).to eq([collection.id, "abcdefgh"])
    end

    it "responds with a JSON success" do
      allow(SecureRandom).to receive(:hex) { "abcdefgh" }
      encrypted_id = controller.send(:verifier).generate("abcdefgh")

      post :create, params: params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq("id" => encrypted_id)
    end
  end

  describe "GET #status" do
    let(:params) do
      {
        format: "json",
        collection_id: collection.share_id,
        download_id: encrypted_id
      }
    end

    before do
      service.update(link_sharing_enabled: true)
      reset_dir!(download_dir)
    end

    context "user is not authenticated" do
      before { session[:user_id] = nil }

      it "still calls the controller action" do
        get :status, params: params

        expect(response.code).to eq("200")
      end
    end

    context "request is not json format" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        get :status, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      before { params[:collection_id] = "abcde" }

      it "returns a 400 Error JSON response" do
        get :status, params: params

        expect(JSON.parse(response.body)).to eq({})
        expect(response.code).to eq("400")
      end
    end

    context "collection is not shared" do
      before { service.update(link_sharing_enabled: false) }

      it "returns a 400 Error JSON response" do
        get :status, params: params

        expect(JSON.parse(response.body)).to eq({})
        expect(response.code).to eq("400")
      end
    end

    context "encrypted id is invalid" do
      before { params[:encrypted_id] = "something-fake" }

      it "returns the status as incomplete" do
        get :status, params: params

        expect(response.code).to eq("200")
        expect(JSON.parse(response.body)).to eq(
          "download" => {
            "isComplete" => false,
            "url" => nil
          }
        )
      end
    end

    it "returns the status when the download is not complete" do
      get :status, params: params

      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq(
        "download" => {
          "isComplete" => false,
          "url" => nil
        }
      )
    end

    it "returns the status when the download is complete" do
      create_download_file(fixture: "images/chennai.jpg")
      create_download_file(fixture: "images/atlanta.jpg")
      create_download_bundle(name: "file.zip")

      get :status, params: params

      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq(
        "download" => {
          "isComplete" => true,
          "url" => collection_download_url(
            collection_id: collection.share_id,
            id: encrypted_id
          )
        }
      )
    end
  end
end
