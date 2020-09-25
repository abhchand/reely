require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #index' do
    let(:collection) { create_collection_with_photos(owner: user) }

    it 'assigns @photos owned by this user and @photo_count' do
      photo1 = create(:photo, owner: user, taken_at: 2.days.ago)
      photo2 = create(:photo, owner: user, taken_at: 1.days.ago)
      create(:photo)

      get :index

      expect(assigns(:photos)).to eq([photo2, photo1])
      expect(assigns(:photo_count)).to eq(2)
    end

    it 'assignes @collections by this user' do
      collection = create_collection_with_photos(owner: user)
      _other_collection = create_collection_with_photos

      get :index

      expect(assigns(:collections)).to eq([collection])
    end
  end

  describe 'GET #new' do
    it 'renders the new action' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload('images/atlanta.jpg', 'image/jpeg') }

    let(:params) { { format: 'json', photo: { source_file: file } } }

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        post :create, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'file upload fails' do
      before do
        allow_any_instance_of(Photos::ImportService).to receive(:file_exists?) {
          false
        }
      end

      it 'does not upload the file and responds with an error' do
        expect { post :create, params: params }.to_not(change { Photo.count })

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).to eq(
          'error' => t('photos.import_service.generic_error')
        )
      end
    end

    it 'uploads the file and responds with a success' do
      expect { post :create, params: params }.to change { Photo.count }.by(1)

      photo = Photo.last
      tile_path =
        PhotoPresenter.new(photo, view: nil).source_file_path(size: :tile)

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        'paths' => { 'tile' => tile_path }
      )

      expect(photo.owner).to eq(user)
      expect(photo.source_file.attached?).to eq(true)
      expect(photo.source_file_blob.filename).to eq('atlanta.jpg')
    end
  end
end
