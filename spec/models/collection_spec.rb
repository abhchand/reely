require "rails_helper"
require "models/concerns/has_synthetic_id_spec"

RSpec.describe Collection, type: :model do
  it_behaves_like "has synthetic id"

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_many(:photo_collections).inverse_of(:collection) }
    it { should have_many(:photos).through(:photo_collections) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end

  describe "#cover_photos" do
    let(:collection) { create_collection_with_photos(photo_count: 3) }

    it "returns the earliest photos in the collection" do
      photos = collection.photos.order(:created_at).first(3)
      expect(collection.cover_photos).to eq(photos)
    end
  end
end
