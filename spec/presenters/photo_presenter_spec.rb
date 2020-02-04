require "rails_helper"

RSpec.describe PhotoPresenter, type: :presenter do
  let(:model) { create(:photo) }
  let(:photo) { PhotoPresenter.new(model, view: view_context) }

  describe "#source_file_path" do
    it "returns the URL path to the original image" do
      path = raw_photo_path(id: photo.direct_access_key)
      expect(photo.source_file_path).to eq(path)
    end

    context "size specified" do
      it "returns the URL path to the specified size" do
        path =
          raw_photo_path(id: photo.direct_access_key, size: :thumb)
        expect(photo.source_file_path(size: :thumb)).to eq(path)
      end

      it "ignores the size when invalid" do
        path = raw_photo_path(id: photo.direct_access_key)
        expect(photo.source_file_path(size: :foo)).to eq(path)
      end
    end
  end

  describe "#taken_at_label" do
    let(:model) { create(:photo, taken_at: Time.zone.parse("Jan 01, 2019")) }

    it "returns the formatted taken_at" do
      expect(photo.taken_at_label).to eq("Jan 2019")
    end
  end
end
