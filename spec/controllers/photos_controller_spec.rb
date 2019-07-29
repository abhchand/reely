require "rails_helper"

RSpec.describe PhotosController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET index" do
    let(:collection) { create_collection_with_photos(owner: user) }

    it "assigns @photos owned by this user and @photo_count" do
      photo1 = create(:photo, owner: user, taken_at: 2.days.ago)
      photo2 = create(:photo, owner: user, taken_at: 1.days.ago)
      create(:photo)

      get :index

      expect(assigns(:photos)).to eq([photo2, photo1])
      expect(assigns(:photo_count)).to eq(2)
    end

    it "assignes @collections by this user" do
      collection = create_collection_with_photos(owner: user)
      _other_collection = create_collection_with_photos

      get :index

      expect(assigns(:collections)).to eq([collection])
    end
  end
end
