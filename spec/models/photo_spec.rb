require "rails_helper"
require "models/concerns/has_synthetic_id_spec"

RSpec.describe Photo, type: :model do
  it_behaves_like "has synthetic id"

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_many(:photo_collections).inverse_of(:photo) }
    it { should have_many(:collections).through(:photo_collections) }
  end

  describe "Validations" do
    it { should have_attached_file(:source) }
    it { should validate_attachment_presence(:source) }
    it do
      # `allowing` doesn't really support regex, so settle for static type
      should validate_attachment_content_type(:source).allowing("image/png")
    end
  end

  describe "#taken_at_display_label" do
    it "returns the formatted taken_at if present" do
      photo = create(:photo, taken_at: Time.zone.now)

      label = l(photo.taken_at, format: :month_and_year)
      expect(photo.taken_at_display_label).to eq(label)
    end

    it "returns the placeholder label if taken_at is not present" do
      photo = create(:photo, taken_at: nil)

      label = t("activerecord.attributes.photo.unknown_taken_at")
      expect(photo.taken_at_display_label).to eq(label)
    end
  end
end
