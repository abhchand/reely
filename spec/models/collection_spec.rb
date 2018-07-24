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
end
