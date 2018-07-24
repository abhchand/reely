require "rails_helper"

RSpec.describe PhotosController, type: :controller do
  let(:user) { create(:user) }
  before { session[:user_id] = user.id }

  describe "GET index" do
    it "assigns @photos owned by this user" do
      photo1 = create(:photo, owner: user, taken_at: 2.days.ago)
      photo2 = create(:photo, owner: user, taken_at: 1.days.ago)
      create(:photo)

      get :index

      expect(assigns(:photos)).to eq([photo2, photo1])
    end
  end
end
