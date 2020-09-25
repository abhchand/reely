require 'rails_helper'

RSpec.describe BundleFilesJob, type: :worker do
  let(:user) { create(:user) }

  let(:collection) do
    # Avoid using `create_collection_with_photos()` helper here because we
    # want to (a) specify a custom collection name and (b) specify custom
    # (unique) fixture files for each photo

    create(:collection, owner: user, name: 'lima').tap do |collection|
      photos = [
        create(:photo, owner: user, source_file_name: 'atlanta.jpg'),
        create(:photo, owner: user, source_file_name: 'chennai.jpg')
      ]

      photos.each do |photo|
        create(:photo_collection, photo: photo, collection: collection)
      end
    end
  end

  let(:uuid) { SecureRandom.hex }

  let(:download_dir) { Rails.configuration.x.default_download_dir.join(uuid) }

  before { reset_dir!(download_dir) }

  context 'collection has no photos' do
    before { collection.photos.destroy_all }

    it 'does not create any files' do
      # NOTE: The `download_dir` directory does get created because it's
      # called via `reset_dir!` in the `before{}` hook

      BundleFilesJob.new.perform(collection.id, uuid)
      expect(Dir[download_dir.join('*')]).to be_empty
    end
  end

  it 'bundles all photos using the collection name' do
    expect { BundleFilesJob.new.perform(collection.id, uuid) }.to change {
      Dir[download_dir.join('*.zip')].count
    }.from(0).to(1)

    bundle_filepath = Pathname.new(Dir[download_dir.join('*.zip')][0])

    # Validate bundle name
    expect(bundle_filepath.basename.to_s).to eq('lima.zip')

    # Remove existing photos
    Dir[download_dir.join('*.jpg')].each { |file| FileUtils.rm(file) }

    # Unzip the file
    cmd = %w[unzip -q lima.zip].join(' ')
    Dir.chdir(download_dir) { raise unless system(cmd) }

    # Validate its contents
    files =
      Dir[download_dir.join('*.jpg')].map do |file|
        Pathname.new(file).basename.to_s
      end
    expect(files).to match_array(%w[atlanta.jpg chennai.jpg])
  end

  it 'schedules the deletion job' do
    freeze_time do
      expect { BundleFilesJob.new.perform(collection.id, uuid) }.to(
        change { DeleteFileBundleJob.jobs.size }.by(1)
      )

      job = DeleteFileBundleJob.jobs.last
      expect(job['at']).to eq(BundleFilesJob::TTL.from_now.to_i)
    end
  end

  describe 'bundle name' do
    it 'replaces the collection name with spaces' do
      collection.update!(name: 'Name with Spaces')

      BundleFilesJob.new.perform(collection.id, uuid)

      bundle_filepath = Pathname.new(Dir[download_dir.join('*.zip')][0])
      expect(bundle_filepath.basename.to_s).to eq('Name-with-Spaces.zip')
    end

    it 'escapes characters to work with shell naming' do
      collection.update!(name: "Name'that;`ls`;esc#aped")

      BundleFilesJob.new.perform(collection.id, uuid)

      bundle_filepath = Pathname.new(Dir[download_dir.join('*.zip')][0])
      expect(bundle_filepath.basename.to_s).to eq("Name'that;`ls`;esc#aped.zip")
    end
  end
end
