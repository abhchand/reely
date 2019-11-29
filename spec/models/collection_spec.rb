require "rails_helper"
# rubocop:disable Metrics/LineLength
require Rails.root.join("spec/support/shared_examples/models/concerns/has_synthetic_id").to_s
require Rails.root.join("spec/support/shared_examples/models/concerns/has_share_id").to_s
# rubocop:enable Metrics/LineLength

RSpec.describe Collection, type: :model do
  it_behaves_like "has synthetic id"

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_many(:photo_collections).inverse_of(:collection) }
    it { should have_many(:photos).through(:photo_collections) }
    it { should have_many(:shared_collection_recipients) }
    it do
      should have_many(:sharing_recipients).
        through(:shared_collection_recipients)
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }

    describe "#sharing_config" do
      it { should allow_value({}).for(:sharing_config) }
      it { should allow_value("foo" => "bar").for(:sharing_config) }
      it { should_not allow_value(nil).for(:sharing_config) }
    end
  end

  describe "#cover_photos" do
    let(:collection) { create_collection_with_photos(photo_count: 3) }

    it "returns the earliest photos in the collection" do
      photos = collection.photos.order(:created_at).first(3)
      expect(collection.cover_photos).to eq(photos)
    end
  end
end
