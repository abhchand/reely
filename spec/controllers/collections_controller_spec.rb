require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET index' do
    it "assigns @collections as all of current user's collections" do
      c1 = create(:collection, owner: user, created_at: 2.days.ago)
      _c2 = create(:collection)
      c3 = create(:collection, owner: user, created_at: 1.day.ago)

      get :index

      expect(assigns(:collections)).to eq([c3, c1])
    end
  end

  describe 'GET #show' do
    let(:collection) { create_collection_with_photos(owner: user) }

    context 'collection is not found' do
      it 'redirects to the root path' do
        get :show, params: { id: 'abcde' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'collection is not owned by current_user' do
      before { collection.update!(owner: create(:user)) }

      it 'redirects to the root path' do
        get :show, params: { id: collection.synthetic_id }
        expect(response).to redirect_to(root_path)
      end
    end

    it 'assigns the collection(s), photo, and date range label' do
      # Ensure `collection` is created first
      collection

      other_collection = create(:collection, owner: user)
      _irrelevant_collection = create(:collection)

      expect(DateRangeLabelService).to receive(:call) { 'some label' }

      get :show, params: { id: collection.synthetic_id }

      expect(assigns(:collection)).to eq(collection)
      expect(assigns(:collections)).to eq([other_collection, collection])
      expect(assigns(:photos)).to eq(collection.photos.order(:taken_at))
      expect(assigns(:photo_count)).to eq(2)
      expect(assigns(:date_range_label)).to eq('some label')
    end
  end

  describe 'POST #create' do
    let(:params) { { collection: { name: 'Some Name' } } }

    it 'creates the collection' do
      expect { post :create, params: params }.to change { Collection.count }.by(
        1
      )

      collection = Collection.last
      expect(collection.owner).to eq(user)
      expect(collection.name).to eq('Some Name')
    end

    context 'format json' do
      before { params[:format] = 'json' }

      it 'returns a 200 OK JSON response' do
        post :create, params: params

        collection = Collection.last
        expect(JSON.parse(response.body)).to eq(collection.as_json)
        expect(response.code).to eq('200')
      end

      context 'error in creating collection' do
        before { allow_any_instance_of(Collection).to receive(:save) { false } }

        it 'returns a 400 Error JSON response' do
          post :create, params: params

          expect(JSON.parse(response.body)).to eq({})
          expect(response.code).to eq('400')
        end
      end
    end

    context 'format html' do
      it 'redirects to the show page for the new collection' do
        post :create, params: params

        collection = Collection.last
        expect(response).to redirect_to(collection_path(collection))
      end

      context 'error in creating collection' do
        before { allow_any_instance_of(Collection).to receive(:save) { false } }

        it 'redirects to root_path with a flash error' do
          post :create, params: params

          expect(response).to redirect_to(root_path)
          expect(flash['error']).to eq(t('collections.create.error'))
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:collection) { create_collection_with_photos(owner: user) }

    let(:params) do
      {
        format: 'json',
        id: collection.synthetic_id,
        collection: { name: collection.name }
      }
    end

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        put :update, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'collection is not found' do
      it 'redirects to the root path' do
        put :update, params: params.merge(id: 'abcde')

        expect(response.status).to eq(404)
        expect(response.body).to eq('{}')
      end
    end

    context 'collection is not owned by current_user' do
      before { collection.update!(owner: create(:user)) }

      it 'redirects to the root path' do
        put :update, params: params

        expect(response.status).to eq(403)
        expect(response.body).to eq('{}')
      end
    end

    it 'updates the collection and responds as success' do
      params[:collection][:name] = 'Some new name'

      put :update, params: params

      expect(collection.reload.name).to eq('Some new name')
      expect(response.status).to eq(200)
      expect(response.body).to eq('{}')
    end

    context 'there is an error while updating collection' do
      it 'does not update the collection and responds as failure' do
        old_name = collection.name
        params[:collection][:name] = ''

        put :update, params: params

        expect(collection.reload.name).to eq(old_name)

        expect(response.status).to eq(400)
        expect(response.body).to eq('{}')
      end
    end
  end

  describe 'PUT #add_photos' do
    let(:collection) { create(:collection, owner: user) }
    let(:photos) { create_list(:photo, 2, owner: user) }

    let(:params) do
      {
        format: 'json',
        collection_id: collection.synthetic_id,
        collection: { photo_ids: photos.map(&:synthetic_id) }
      }
    end

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        put :add_photos, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'collection is not found' do
      it 'redirects to the root path' do
        put :add_photos, params: params.merge(collection_id: 'abcde')

        expect(response.status).to eq(404)
        expect(response.body).to eq('{}')
      end
    end

    context 'collection is not owned by current_user' do
      before { collection.update!(owner: create(:user)) }

      it 'redirects to the root path' do
        put :add_photos, params: params

        expect(response.status).to eq(403)
        expect(response.body).to eq('{}')
      end
    end

    it 'adds photos to the collection and responds as success' do
      put :add_photos, params: params

      expect(collection.reload.photos).to match_array(photos)
      expect(response.status).to eq(200)
      expect(response.body).to eq('{}')
    end

    context 'there is an error while adding photos to collection' do
      let(:service) { double('AddPhotosToCollection') }

      before do
        allow(AddPhotosToCollection).to receive(:call) { service }
        allow(service).to receive(:success?) { false }
      end

      it 'responds as failure' do
        put :add_photos, params: params

        expect(collection.reload.photos).to eq([])

        expect(response.status).to eq(400)
        expect(response.body).to eq('{}')
      end
    end
  end

  describe 'PUT #remove_photos' do
    let(:photos) { collection.photos }
    let(:collection) do
      create_collection_with_photos(owner: user, photo_count: 2)
    end

    let(:params) do
      {
        format: 'json',
        collection_id: collection.synthetic_id,
        collection: { photo_ids: photos.map(&:synthetic_id) }
      }
    end

    before { expect(collection.reload.photos).to match_array(photos) }

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        put :remove_photos, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'collection is not found' do
      it 'redirects to the root path' do
        put :remove_photos, params: params.merge(collection_id: 'abcde')

        expect(response.status).to eq(404)
        expect(response.body).to eq('{}')
      end
    end

    context 'collection is not owned by current_user' do
      before { collection.update!(owner: create(:user)) }

      it 'redirects to the root path' do
        put :remove_photos, params: params

        expect(response.status).to eq(403)
        expect(response.body).to eq('{}')
      end
    end

    it 'removes photos from the collection and responds as success' do
      put :remove_photos, params: params

      expect(collection.reload.photos).to eq([])
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        'date_range_label' => nil, 'photo_count' => 0
      )
    end

    context 'there is an error while removing photos from collection' do
      let(:service) { double('RemovePhotosFromCollection') }

      before do
        allow(RemovePhotosFromCollection).to receive(:call) { service }
        allow(service).to receive(:success?) { false }
      end

      it 'responds as failure' do
        put :remove_photos, params: params

        expect(collection.reload.photos).to match_array(photos)

        expect(response.status).to eq(400)
        expect(response.body).to eq('{}')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:collection) { create_collection_with_photos(owner: user) }
    let(:params) { { format: 'json', id: collection.synthetic_id } }

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        delete :destroy, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'collection is not found' do
      before { params[:id] = 'abcde' }

      it 'redirects to the root path' do
        delete :destroy, params: params

        expect(response.status).to eq(404)
        expect(response.body).to eq('{}')
      end
    end

    context 'collection is not owned by current_user' do
      before { collection.update!(owner: create(:user)) }

      it 'redirects to the root path' do
        delete :destroy, params: params

        expect(response.status).to eq(403)
        expect(response.body).to eq('{}')
      end
    end

    it 'destroys the collection and responds as success' do
      delete :destroy, params: params

      expect { collection.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response.status).to eq(200)
      expect(response.body).to eq('{}')
    end

    context 'there is an error while updating collection' do
      it 'does not destroy the collection and responds as failure' do
        allow_any_instance_of(Collection).to receive(:destroy) { false }

        delete :destroy, params: params

        expect { collection.reload }.to_not raise_error

        expect(response.status).to eq(400)
        expect(response.body).to eq('{}')
      end
    end
  end
end
