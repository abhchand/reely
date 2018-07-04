require "rails_helper"

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }
  before { session[:user_id] = user.id }

  describe "GET index" do
    it "assigns @photos" do
      photo1 = create(:photo, taken_at: 2.days.ago)
      photo2 = create(:photo, taken_at: 1.days.ago)

      get :index

      expect(assigns(:photos)).to eq([photo2, photo1])
    end
  end
end
