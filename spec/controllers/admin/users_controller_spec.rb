require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) do
    create(:user, :admin, first_name: 'Alonso', last_name: 'Harris')
  end

  before { sign_in(admin) }

  describe 'GET index' do
    it 'calls the `admin_only` filter' do
      expect(controller).to receive(:admin_only).and_call_original
      get :index
    end

    it 'should render the template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
