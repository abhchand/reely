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
end
