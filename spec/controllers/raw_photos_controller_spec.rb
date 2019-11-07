require "rails_helper"

RSpec.describe RawPhotosController, type: :controller do
  let(:photo) { create(:photo) }

  before { photo }

  describe "GET show" do
    it "returns the photo source file inline" do
      expect_file_served_for(photo)
      get :show, params: { id: photo.direct_access_key }
    end

    it "also work with authentication" do
      session[:user_id] = photo.owner.id

      expect_file_served_for(photo)
      get :show, params: { id: photo.direct_access_key }
    end

    context "photo record not found" do
      it "redirects to the root path" do
        get :show, params: { id: "abcde" }
        expect(response).to redirect_to(root_path)
      end
    end

    context "source_file is not processed" do
      before do
        transformations = Photo::SOURCE_FILE_SIZES[:medium]
        variant = photo.source_file.variant(transformations)
        File.delete(variant.service.path_for(variant.key))

        expect(variant.send(:processed?)).to be_falsey
      end

      it "redirects to the root path" do
        get :show, params: { id: photo.direct_access_key, size: "medium" }
        expect(response).to redirect_to(root_path)
      end
    end

    context ":size param is specified" do
      it "returns the photo source file inline" do
        expect_file_served_for(photo, :medium)
        get :show, params: { id: photo.direct_access_key, size: "medium" }
      end

      it ":size param is case insensitive" do
        expect_file_served_for(photo, :medium)
        get :show, params: { id: photo.direct_access_key, size: "MEDiUm" }
      end

      context ":size param is invalid" do
        it "redirects to the root_path" do
          get :show, params: { id: "abcde" }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  def expect_file_served_for(photo, size = nil)
    # rubocop:disable LineLength
    transformations = Photo::SOURCE_FILE_SIZES[size&.to_sym]
    filename = "#{photo.direct_access_key}.jpg"

    blob_or_variant = photo.source_file_blob
    blob_or_variant = blob_or_variant.variant(transformations) if transformations

    path = ActiveStorage::Blob.service.path_for(blob_or_variant.key)
    content_type = blob_or_variant.send(:content_type)
    disposition = "inline; filename=\"#{filename}\"; filename*=UTF-8''#{filename}"

    opts = { content_type: content_type, disposition: disposition }
    # rubocop:enable LineLength

    expect(controller).to receive(:serve_file).
      with(path, opts).
      and_call_original
  end
end