require "rails_helper"

RSpec.describe AddPhotosToCollection, type: :service do
  describe "#call" do
    let(:user) { create(:user) }

    let(:photos) { create_list(:photo, 2, owner: user) }
    let(:collection) { create(:collection, owner: user) }

    let(:params) do
      {
        photo_ids: photos.map(&:synthetic_id)
      }
    end

    it "adds the photos to the specified collection" do
      response = call
      expect(response.success?).to eq(true)
      expect(collection.reload.photos).to match_array(photos)
    end

    it "doesn't add photos to other collections" do
      other_collection = create(:collection, owner: user)

      response = call
      expect(response.success?).to eq(true)
      expect(other_collection.photos).to eq([])
    end

    it "handles duplicate photo ids" do
      photo_ids = photos.map(&:synthetic_id) + [photos[0].synthetic_id]
      params[:photo_ids] = photo_ids

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to match_array(photos)
      end.to change { PhotoCollection.count }.by(2)
    end

    it "handles invalid photo ids" do
      params[:photo_ids] << "abcde"

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to match_array(photos)
      end.to change { PhotoCollection.count }.by(2)
    end

    it "handles photos that already exist in the collection" do
      PhotoCollection.create!(photo: photos[0], collection: collection)

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to match_array(photos)
      end.to change { PhotoCollection.count }.by(1)
    end

    context "photo creation fails" do
      before do
        # Ensure records are created before stubbing `:save` below
        params

        # Return `false` on the second record to be saved
        # rubocop:disable LineLength
        allow_any_instance_of(PhotoCollection).to receive(:save).and_wrap_original do |method|
          PhotoCollection.count.zero? ? method.call : false
        end
        # rubocop:enable LineLength
      end

      it "rolls back all created PhotoCollection records" do
        expect do
          response = call

          expect(response.success?).to eq(false)
          expect(collection.reload.photos).to eq([])
        end.to_not(change { PhotoCollection.count })
      end
    end
  end

  def call
    AddPhotosToCollection.call(collection: collection, params: params)
  end
end
