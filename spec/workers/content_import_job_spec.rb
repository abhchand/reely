require "rails_helper"

RSpec.describe ContentImportJob, type: :worker do
  let(:import_dir) { Rails.configuration.x.default_import_dir }
  let(:owner) { create(:user) }

  let(:filepath) do
    create_import_file(owner: owner, fixture: "images/chennai.jpg")
  end

  before { reset_dir!(import_dir) }

  describe "creating Photo record" do
    let(:exif_data) do
      {
        "date_time_original" => "2019:03:14 13:00:00",
        "gps_latitude" => 38.8721,
        "gps_latitude_ref" => "North",
        "gps_longitude" => -99.3302532,
        "gps_longitude_ref" => "West"
      }
    end

    before { reset_exif_data }

    it "creates the Photo record" do
      expect do
        ContentImportJob.new.perform(owner.id, filepath)
      end.to change { Photo.count }.by(1)

      photo = Photo.first

      expect(photo.owner).to eq(owner)
      exif_data.each do |key, value|
        expect(photo.exif_data[key]).to eq(value)
      end
    end

    it "attaches the source file" do
      ContentImportJob.new.perform(owner.id, filepath)

      photo = Photo.first

      expect(photo.source_file.attached?).to eq(true)
      expect(photo.source_file_blob.filename).to eq(filepath.basename)
    end
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
  end

  context "file does not exist" do
    it "exits the job without error" do
      bad_filepath = Pathname.new(filepath.to_s + ".foo")

      expect do
        ContentImportJob.new.perform(owner.id, bad_filepath)
      end.to_not raise_error

      expect(Photo.count).to eq(0)
      expect(filepath.exist?).to eq(true)
    end
  end

  describe "detecting duplicate files" do
    context "duplicate file exists for the owner" do
      let(:dup_filepath) { filepath.dirname.join("chennai-dup.jpg") }

      before do
        `cp #{filepath} #{dup_filepath}`
        expect(dup_filepath.exist?).to eq(true)
      end

      it "does not import the duplicate file" do
        expect do
          ContentImportJob.new.perform(owner.id, filepath)
          ContentImportJob.new.perform(owner.id, dup_filepath)
        end.to change { Photo.count }.by(1)

        photo = Photo.first

        expect(photo.source_file_blob.filename).to eq(filepath.basename)
      end

      it "removes the file and directory" do
        file_and_dir_removed = proc do
          !filepath.exist? && !filepath.dirname.exist?
        end

        expect do
          ContentImportJob.new.perform(owner.id, filepath)
          ContentImportJob.new.perform(owner.id, dup_filepath)
        end.to change { file_and_dir_removed.call }.from(false).to(true)
      end

      context "other files still exist in the directory" do
        let(:other_filepath) do
          create_import_file(owner: owner, fixture: "images/atlanta.jpg")
        end

        before { other_filepath }

        it "removes the file but not the directory" do
          expect(filepath.exist?).to eq(true)
          expect(dup_filepath.exist?).to eq(true)
          expect(other_filepath.exist?).to eq(true)

          expect do
            ContentImportJob.new.perform(owner.id, filepath)
            ContentImportJob.new.perform(owner.id, dup_filepath)
          end.to_not(change { filepath.dirname.exist? })

          expect(filepath.exist?).to eq(false)
          expect(dup_filepath.exist?).to eq(false)
          expect(other_filepath.exist?).to eq(true)
        end
      end
    end

    context "duplicate file exists, but for another owner" do
      let(:other_owner) { create(:user) }
      let(:dup_filepath) do
        create_import_file(owner: other_owner, fixture: "images/chennai.jpg")
      end

      before do
        expect(dup_filepath.exist?).to eq(true)
      end

      it "imports the file for the new owner" do
        expect do
          ContentImportJob.new.perform(owner.id, filepath)
          ContentImportJob.new.perform(other_owner.id, dup_filepath)
        end.to change { Photo.count }.by(2)

        photo = Photo.first
        expect(photo.source_file_blob.filename).to eq(filepath.basename)

        photo = Photo.last
        expect(photo.source_file_blob.filename).to eq(dup_filepath.basename)
      end
    end
  end

  context "error while creating the DB records" do
    before do
      allow_any_instance_of(Photo).to receive(:source_file).and_raise("💣")
    end

    it "rolls back any DB changes" do
      expect do
        ContentImportJob.new.perform(owner.id, filepath)
      end.to raise_error("💣")

      expect(filepath.exist?).to eq(true)
    end
  end

  def reset_exif_data
    strip_and_rewrite_exif_data(filepath: filepath, exif_data: exif_data)
  end
end
