require "rails_helper"
# rubocop:disable LineLength
require Rails.root.join("spec/support/shared_examples/models/concerns/has_synthetic_id").to_s
require Rails.root.join("spec/support/shared_examples/models/concerns/has_direct_access_key").to_s
# rubocop:enable LineLength

RSpec.describe Photo, type: :model do
  it_behaves_like "has synthetic id"
  it_behaves_like "has direct access key"

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_many(:photo_collections).inverse_of(:photo) }
    it { should have_many(:collections).through(:photo_collections) }
  end

  describe "Validations" do
    it { should validate_presence_of(:taken_at) }
    it { should validate_presence_of(:width) }
    it { should validate_presence_of(:height) }
    it { should have_attached_file(:source) }
    it { should validate_attachment_presence(:source) }
    it do
      # `allowing` doesn't really support regex, so settle for static type
      should validate_attachment_content_type(:source).allowing("image/png")
    end
  end

  describe "#taken_at_display_label" do
    it "returns the formatted taken_at" do
      photo = create(:photo, taken_at: Time.zone.now)

      label = l(photo.taken_at, format: :month_and_year)
      expect(photo.taken_at_display_label).to eq(label)
    end
  end
end
