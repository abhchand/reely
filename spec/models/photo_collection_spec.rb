require "rails_helper"

RSpec.describe PhotoCollection, type: :model do
  subject { create(:photo_collection) }

  describe "Associations" do
    it { should belong_to(:photo) }
    it { should belong_to(:collection) }
  end

  describe "Validations" do
    it { should validate_presence_of(:photo) }
    it { should validate_presence_of(:collection) }
    it { should validate_uniqueness_of(:collection_id).scoped_to(:photo_id) }
  end
end
