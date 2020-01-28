require "rails_helper"

RSpec.describe Photos::ImportService, type: :interactor do
  let(:import_dir) { Rails.configuration.x.default_import_dir }
  let(:owner) { create(:user) }

  let(:filepath) do
    create_import_file(owner: owner, fixture: "images/chennai.jpg")
  end

  let(:exif_data) do
    {
      "date_time_original" => "2019:03:14 13:00:00",
      "gps_latitude" => 38.8721,
      "gps_latitude_ref" => "North",
      "gps_longitude" => -99.3302532,
      "gps_longitude_ref" => "West"
    }
  end

  before do
    reset_dir!(import_dir)
    @t_prefix = "photos.import_service"
  end

  it "creates a Photo with source file attachment" do
    reset_exif_data

    result = nil
    expect { result = call }.to(change { Photo.count }.by(1))

    photo = Photo.last

    expect(result.success?).to eq(true)
    expect(result.log).to be_nil
    expect(result.error).to be_nil
    expect(result.photo).to eq(photo)

    expect(photo.owner).to eq(owner)
    expect(photo.source_file.attached?).to eq(true)
    expect(photo.source_file_blob.filename).to eq(filepath.basename)
    exif_data.each { |key, value| expect(photo.exif_data[key]).to eq(value) }
  end

  context "file does not exist" do
    before { @bad_filepath = Pathname.new(filepath.to_s + ".foo") }

    it "does not create the Photo" do
      result = nil
      expect do
        result = call(filepath: @bad_filepath)
      end.to_not(change { Photo.count })

      expect(result.success?).to eq(false)
      expect(result.log).to_not be_nil
      expect(result.error).to eq(t("#{@t_prefix}.generic_error"))
      expect(result.photo).to be_nil
    end
  end

  context "file content type is invalid" do
    let(:filepath) do
      create_import_file(owner: owner, fixture: "text/quotes.md")
    end

    it "does not create the Photo" do
      result = nil
      expect { result = call }.to_not(change { Photo.count })

      expect(result.success?).to eq(false)
      expect(result.log).to_not be_nil
      expect(result.error).to eq(t("#{@t_prefix}.invalid_content_type"))
      expect(result.photo).to be_nil
    end
  end

  describe "detecting duplicate files" do
    context "duplicate file exists for the same owner" do
      let(:dup_filepath) { filepath.dirname.join("chennai-dup.jpg") }

      before do
        `cp #{filepath} #{dup_filepath}`
        expect(dup_filepath.exist?).to eq(true)
      end

      it "does not create a duplicate Photo" do
        result = nil

        expect do
          call(filepath: filepath)
          result = call(filepath: dup_filepath)
        end.to change { Photo.count }.by(1)

        photo = Photo.last
        expect(photo.source_file_blob.filename).to eq(filepath.basename)

        expect(result.success?).to eq(false)
        expect(result.log).to_not be_nil
        expect(result.error).to eq(t("#{@t_prefix}.duplicate_image"))
        expect(result.photo).to be_nil
      end
    end

    context "duplicate file exists, but for another owner" do
      let(:other_owner) { create(:user) }
      let(:dup_filepath) do
        # `owner:` here just creates the file under another import
        # subdirectory for `other_owner`. We still need to specify the
        # owner to this service using the `owner:` param in `call()` below
        create_import_file(owner: other_owner, fixture: "images/chennai.jpg")
      end

      before do
        expect(dup_filepath.exist?).to eq(true)
      end

      it "imports the file for each owner" do
        result = nil
        expect do
          call(owner: other_owner, filepath: filepath)
          result = call(owner: owner, filepath: dup_filepath)
        end.to change { Photo.count }.by(2)

        photo = Photo.first
        expect(photo.source_file_blob.filename).to eq(filepath.basename)

        photo = Photo.last
        expect(photo.source_file_blob.filename).to eq(dup_filepath.basename)

        expect(result.success?).to eq(true)
        expect(result.log).to be_nil
        expect(result.error).to be_nil
        expect(result.photo).to eq(photo)
      end
    end
  end

  context "error while creating the DB records" do
    before do
      expect_any_instance_of(Photo).to receive(:source_file).and_raise("💣")
    end

    it "rolls back any DB changes" do
      result = nil
      expect { result = call }.to_not(change { Photo.count })

      expect(result.success?).to eq(false)
      expect(result.log).to_not be_nil
      expect(result.error).to eq(t("#{@t_prefix}.generic_error"))
      expect(result.photo.persisted?).to eq(false)
    end
  end

  def reset_exif_data
    strip_and_rewrite_exif_data(filepath: filepath, exif_data: exif_data)
  end

  def call(opts = {})
    Photos::ImportService.call(
      { owner: owner, filepath: filepath }.merge(opts)
    )
  end
end
