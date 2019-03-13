require "rails_helper"
# rubocop:disable LineLength
require Rails.root.join("spec/support/shared_examples/models/concerns/has_synthetic_id").to_s
require Rails.root.join("spec/support/shared_examples/models/concerns/has_direct_access_key").to_s
# rubocop:enable LineLength

RSpec.describe Photo, type: :model do
  let(:photo) { create(:photo) }

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
  end

  describe "#taken_at_display_label" do
    it "returns the formatted taken_at" do
      photo = create(:photo, taken_at: Time.zone.now)

      label = l(photo.taken_at, format: :month_and_year)
      expect(photo.taken_at_display_label).to eq(label)
    end
  end

  describe "callbacks" do
    describe "after_commit" do
      describe "#process_all_variants" do
        before do
          # Explicitly clear the storage before these tests since they
          # test whether variants have been processed on the disk or not and
          # we want to avoid false positives from files created during other
          # tests
          clear_storage!
        end

        context "on attachment create" do
          it "processes all variants" do
            photo = create(:photo, with_source_file: false)
            attach_photo_fixture(photo: photo, fixture: "atlanta.jpg")

            expect_all_variants_processed(photo)
          end
        end

        context "on attachment update" do
          it "processes all variants" do
            expect_all_variants_processed(photo)

            attach_photo_fixture(photo: photo, fixture: "chennai.jpg")
            expect_all_variants_processed(photo)
          end
        end

        context "on attachment destroy" do
          it "processes all variants" do
            expect_all_variants_processed(photo)
            expect { photo.source_file.detach }.to_not raise_error
          end
        end
      end
    end
  end

  describe "#source_file_path" do
    it "returns the URL path to the original image" do
      path =
        Rails.application.routes.url_helpers.
        photos_source_file_path(id: photo.direct_access_key)
      expect(photo.source_file_path).to eq(path)
    end

    context "size specified" do
      it "returns the URL path to the specified size" do
        path =
          Rails.application.routes.url_helpers.
          photos_source_file_path(id: photo.direct_access_key, size: :medium)

        expect(photo.source_file_path(size: :medium)).to eq(path)
      end

      it "ignores the size when invalid" do
        path =
          Rails.application.routes.url_helpers.
          photos_source_file_path(id: photo.direct_access_key)

        expect(photo.source_file_path(size: :foo)).to eq(path)
      end
    end
  end

  def expect_all_variants_processed(photo)
    Photo::SOURCE_FILE_SIZES.each do |_variant, transformations|
      variant = photo.source_file.variant(transformations)
      expect(variant.send(:processed?)).to be_truthy
    end
  end
end
