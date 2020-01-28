require "rails_helper"

RSpec.describe ContentImportJob, type: :worker do
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

  before { reset_dir!(import_dir) }

  it "creates a Photo with source file attachment" do
    reset_exif_data

    expect do
      ContentImportJob.new.perform(owner.id, filepath)
    end.to change { Photo.count }.by(1)

    photo = Photo.first

    expect(photo.owner).to eq(owner)
    exif_data.each do |key, value|
      expect(photo.exif_data[key]).to eq(value)
    end
    expect(photo.source_file.attached?).to eq(true)
    expect(photo.source_file_blob.filename).to eq(filepath.basename)
  end

  describe "file and directory cleanup" do
    it "removes the file and directory" do
      file_and_dir_removed = proc do
        !filepath.exist? && !filepath.dirname.exist?
      end

      expect do
        ContentImportJob.new.perform(owner.id, filepath)
      end.to change { file_and_dir_removed.call }.from(false).to(true)
    end

    context "other files still exist in the directory" do
      let(:other_filepath) do
        create_import_file(owner: owner, fixture: "images/atlanta.jpg")
      end

      before { other_filepath }

      it "removes the file but not the directory" do
        expect(filepath.exist?).to eq(true)
        expect(other_filepath.exist?).to eq(true)

        expect do
          ContentImportJob.new.perform(owner.id, filepath)
        end.to_not(change { filepath.dirname.exist? })

        expect(filepath.exist?).to eq(false)
        expect(other_filepath.exist?).to eq(true)
      end
    end

    context "importing photo fails" do
      before do
        expect_any_instance_of(Photo).to receive(:source_file).and_raise("💣")
      end

      it "does not remove the file or directory" do
        file_and_dir_removed = proc do
          !filepath.exist? && !filepath.dirname.exist?
        end

        expect do
          ContentImportJob.new.perform(owner.id, filepath)
        end.to_not change { file_and_dir_removed.call }
      end
    end
  end

  def reset_exif_data
    strip_and_rewrite_exif_data(filepath: filepath, exif_data: exif_data)
  end
end
