require "rails_helper"

RSpec.describe CollectionsController, type: :controller do
  let(:user) { create(:user) }

  before { session[:user_id] = user.id }

  describe "GET index" do
    it "assigns @collections as all of current user's collections" do
      c1 = create(:collection, owner: user, created_at: 2.days.ago)
      _c2 = create(:collection)
      c3 = create(:collection, owner: user, created_at: 1.day.ago)

      get :index

      expect(assigns(:collections)).to eq([c3, c1])
    end
  end

  describe "GET #show" do
    let(:collection) { create_collection_with_photos(owner: user) }

    context "collection is not found" do
      it "redirects to the root path" do
        get :show, id: "abcde"
        expect(response).to redirect_to(root_path)
      end
    end

    it "assigns the collection, photo, and date range label" do
      expect(DateRangeLabelService).to receive(:call) { "some label" }

      get :show, id: collection.synthetic_id

      expect(assigns(:collection)).to eq(collection)
      expect(assigns(:photos)).to eq(collection.photos.order(:taken_at))
      expect(assigns(:photo_count)).to eq(2)
      expect(assigns(:date_range_label)).to eq("some label")
    end
  end

  describe "PATCH #update" do
    let(:collection) { create_collection_with_photos(owner: user) }

    let(:params) do
      {
        id: collection.synthetic_id,
        collection: {
          name: collection.name
        }
      }
    end

    context "request is not xhr" do
      it "redirects to root_path" do
        put :update, params
        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not found" do
      it "redirects to the root path" do
        xhr :put, :update, params.merge(id: "abcde")
        expect(response).to redirect_to(root_path)
      end
    end

    it "updates the collection and responds as success" do
      params[:collection][:name] = "Some new name"

      xhr :put, :update, params

      expect(collection.reload.name).to eq("Some new name")
      expect(response.status).to eq(200)
      expect(response.body).to eq("{}")
    end

    context "there is an error while updating collection" do
      it "does not update the collection and responds as failure" do
        old_name = collection.name
        params[:collection][:name] = ""

        xhr :put, :update, params

        expect(collection.reload.name).to eq(old_name)
        expect(response.status).to eq(400)
        expect(response.body).to eq("{}")
      end
    end
  end
end
