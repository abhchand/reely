require "rails_helper"

RSpec.feature "downloading files", type: :feature do
  let(:user) { create(:user) }
  let(:collection) do
    # Avoid using `create_collection_with_photos()` helper here because we
    # want to (a) specify a custom collection name and (b) specify custom
    # (unique) fixture files for each photo

    create(:collection, owner: user, name: "lima").tap do |collection|
      photos = [
        create(:photo, owner: user, source_file_name: "atlanta.jpg"),
        create(:photo, owner: user, source_file_name: "chennai.jpg")
      ]

      photos.each do |photo|
        create(:photo_collection, photo: photo, collection: collection)
      end
    end
  end

  let(:service) { Collections::SharingConfigService.new(collection) }
  let(:browser_download_path) { FeatureHelpers::BROWSER_DOWNLOAD_PATH }

  before do
    clear_browser_downloads
    service.update(link_sharing_enabled: true)

    # rubocop:disable Metrics/LineLength
    expect(BundleFilesJob).to receive(:perform_async).and_wrap_original do |_method, *args|
      BundleFilesJob.new.perform(*args)
    end
    # rubocop:enable Metrics/LineLength
  end

  xit "user can download the full collection of photos", :js do
    log_in(user)

    visit collections_sharing_display_path(id: collection.share_id)

    page.find(".file-downloader").click
    wait_for_browser_download

    # Unzip the file
    cmd = ["unzip", "-q", "lima.zip"].join(" ")
    Dir.chdir(browser_download_path) { raise unless system(cmd) }

    # Validate its contents
    files = Dir[browser_download_path.join("*.jpg")]
    expect(files).to match_array(["atlanta.jpg", "chennai.jpg"])
  end
end
