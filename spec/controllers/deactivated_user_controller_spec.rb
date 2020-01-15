require "rails_helper"

RSpec.describe DeactivatedUserController, type: :controller do
  let(:user) { create(:user, :deactivated) }

  before { sign_in(user) }

  describe "GET index" do
    it "renders the action" do
      get :index

      expect(response).to render_template(:index)
    end

    context "user is not deactivated" do
      let(:user) { create(:user) }

      it "redirects to the root path" do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
