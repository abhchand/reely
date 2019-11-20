require "rails_helper"

RSpec.describe RemovePhotosFromCollection, type: :service do
  describe "#call" do
    let(:user) { create(:user) }

    let(:photos) { collection.photos }
    let(:collection) do
      create_collection_with_photos(owner: user, photo_count: 3)
    end

    let(:params) do
      {
        photo_ids: photos.map(&:synthetic_id)
      }
    end

    before { expect(collection.reload.photos).to match_array(photos) }

    it "removes the photos from the specified collection" do
      response = call
      expect(response.success?).to eq(true)
      expect(collection.reload.photos).to eq([])
    end

    it "sets the meta info" do
      response = call
      expect(response.success?).to eq(true)

      meta = {
        date_range_label: DateRangeLabelService.call(collection.reload.photos),
        photo_count: 0
      }

      expect(response.meta).to eq(meta)
    end

    it "doesn't touch other photos in the collection" do
      params[:photo_ids] = photos[0..1].map(&:synthetic_id)

      response = call
      expect(response.success?).to eq(true)
      expect(collection.reload.photos).to eq([photos[2]])

      # Also test at least one case where photo_count > 0

      meta = {
        date_range_label: DateRangeLabelService.call(collection.photos),
        photo_count: 1
      }

      expect(response.meta).to eq(meta)
    end

    it "doesn't remove the specified photos from their other collections" do
      other_collection = create(:collection, owner: user)
      PhotoCollection.create!(collection: other_collection, photo: photos[1])

      response = call
      expect(response.success?).to eq(true)
      expect(other_collection.photos).to eq([photos[1]])
    end

    it "handles duplicate photo ids" do
      photo_ids = photos.map(&:synthetic_id) + [photos[0].synthetic_id]
      params[:photo_ids] = photo_ids

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to eq([])
      end.to change { PhotoCollection.count }.by(-3)
    end

    it "handles invalid photo ids" do
      params[:photo_ids] << "abcde"

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to eq([])
      end.to change { PhotoCollection.count }.by(-3)
    end

    it "handles photos that aren't in the collection" do
      PhotoCollection.
        where(collection: collection, photo: photos[1]).destroy_all

      expect do
        response = call

        expect(response.success?).to eq(true)
        expect(collection.reload.photos).to eq([])
      end.to change { PhotoCollection.count }.by(-2)
    end

    context "photo creation fails" do
      before do
        stub_const("RemovePhotosFromCollection::BATCH_SIZE", 2)

        # Return `nil` on the second batch to be deleted, which will raise
        # an error when `destroy_all` is called on it
        allow(PhotoCollection).to receive(:where).and_wrap_original do |method|
          PhotoCollection.count < 3 ? method.call : nil
        end
      end

      it "rolls back all deleted PhotoCollection records" do
        expect do
          response = call

          expect(response.success?).to eq(false)
          expect(collection.reload.photos).to match_array(photos)
        end.to_not(change { PhotoCollection.count })
      end
    end
  end

  def call
    RemovePhotosFromCollection.call(collection: collection, params: params)
  end
end
