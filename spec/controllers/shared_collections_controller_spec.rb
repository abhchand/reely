require "rails_helper"

RSpec.describe SharedCollectionsController, type: :controller do
  let(:user) { create(:user) }

  before { session[:user_id] = user.id }

  describe "GET #show" do
    let(:collection) { create_collection_with_photos(owner: user) }

    context "collection is not found" do
      it "redirects to the root path" do
        get :show, params: { id: "abcde" }
        expect(response).to redirect_to(root_path)
      end
    end

    context "collection is not owned by current_user" do
      before { collection.update!(owner: create(:user)) }

      it "does not redirect to the root_path" do
        get :show, params: { id: collection.share_id }
        expect(response).to_not redirect_to(root_path)
        expect(assigns(:collection)).to eq(collection)
      end
    end

    it "assigns the collection, photo, and date range label" do
      expect(DateRangeLabelService).to receive(:call) { "some label" }

      get :show, params: { id: collection.share_id }

      expect(assigns(:collection)).to eq(collection)
      expect(assigns(:photos)).to eq(collection.photos.order(:taken_at))
      expect(assigns(:photo_count)).to eq(2)
      expect(assigns(:date_range_label)).to eq("some label")
    end
  end
end
