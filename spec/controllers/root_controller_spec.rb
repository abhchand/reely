require 'rails_helper'

RSpec.describe RootController, type: :controller do
  describe 'GET new' do
    it 'it redirects to new_user_session_path when user is not authenticated' do
      get :new

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'it redirects to photos_path when user is authenticated' do
      user = create(:user)
      log_in(user)

      get :new

      expect(response).to redirect_to(photos_path)
    end
  end
end
