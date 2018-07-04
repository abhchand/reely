require "rails_helper"

RSpec.describe CollectionsController, type: :controller do
  let(:user) { create(:user) }
  before { session[:user_id] = user.id }

  describe "GET index" do
  end
end
