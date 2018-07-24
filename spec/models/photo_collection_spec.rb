require "rails_helper"

RSpec.describe PhotoCollection, type: :model do
  let(:photo) { create(:photo) }
  let(:collection) { create(:collection, owner: photo.owner) }

  subject { create(:photo_collection, photo: photo, collection: collection) }

  describe "Associations" do
    it { should belong_to(:photo) }
    it { should belong_to(:collection) }
  end

  describe "Validations" do
    it { should validate_presence_of(:photo) }
    it { should validate_presence_of(:collection) }
    it { should validate_uniqueness_of(:collection_id).scoped_to(:photo_id) }
  end

  describe "Callbacks" do
    describe "before_save" do
      describe "#validate_owners_match" do
        it "validates the photo and collection owners are the same" do
          photo
          collection

          photo.update!(owner: create(:user))

          expect(subject.errors[:base].first).to match(/Photo owner.*does not/)
        end
      end
    end
  end
end
