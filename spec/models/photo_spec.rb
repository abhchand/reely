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
    describe "#exif_data" do
      it { should allow_value({}).for(:exif_data) }
      it { should allow_value(foo: :bar).for(:exif_data) }
      it { should_not allow_value(nil).for(:exif_data) }
    end

    it { should validate_presence_of(:taken_at) }
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

  context "#taken_at=" do
    let(:time) { "2019-01-01 13:00:00" }

    it "stores as UTC without transforming the timezone" do
      photo.update!(taken_at: time)
      expect(photo.reload.taken_at.strftime("%Y-%m-%d %H:%M:%S")).to eq(time)
    end

    it "correctly handles a nil value" do
      expect(photo.valid?).to eq(true)
      photo.taken_at = nil
      expect(photo.valid?).to eq(false)
    end

    context "a string formattable object is provided" do
      it "stores as UTC without transforming the timezone" do
        time_obj = Time.parse(time)

        photo.update!(taken_at: time_obj)
        expect(photo.reload.taken_at.strftime("%Y-%m-%d %H:%M:%S")).to eq(time)
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
