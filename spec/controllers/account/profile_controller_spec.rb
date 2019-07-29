require "rails_helper"

RSpec.describe Account::ProfileController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET index" do
    it "sets the @name" do
      get :index

      expect(assigns(:user)).to eq(user)
    end
  end
end
