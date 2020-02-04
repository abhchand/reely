require "rails_helper"

RSpec.feature "uploading photos", :js, type: :feature do
  let(:user) { create(:user) }
  let(:upload_dir) { Rails.configuration.x.default_upload_dir }

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
    reset_dir!(upload_dir)

    @filepaths = [
      create_upload_file(fixture: "images/chennai.jpg"),
      create_upload_file(fixture: "images/atlanta.jpg"),
      create_upload_file(fixture: "images/san-francisco.jpg")
    ]

    @filepaths.each do |filepath|
      strip_and_rewrite_exif_data(filepath: filepath, exif_data: exif_data)
    end

    log_in(user)
  end

  it "user can upload photos" do
    visit new_photo_path

    expect do
      upload_file(@filepaths[0])
      wait_for_upload_completion(file_index: 0)
    end.to change { Photo.count }.by(1)

    photo = Photo.last

    expect(photo.owner).to eq(user)
    exif_data.each { |key, value| expect(photo.exif_data[key]).to eq(value) }
    expect(photo.source_file.attached?).to eq(true)

    expect_uploaded_photo(photo, file_index: 0)

    #
    # Upload another round of photos, and test that uploading multiple photos
    # works
    #

    expect do
      upload_file(@filepaths[1..2])
      wait_for_upload_completion(file_index: 0)
      wait_for_upload_completion(file_index: 1)
    end.to change { Photo.count }.by(2)

    photos = Photo.last(2)

    # Looks like the photos are getting created in reverse order in the DB,
    # because of async behavior probably

    expect_uploaded_photo(photos.last, file_index: 0)  # Atlanta
    expect_uploaded_photo(photos.first, file_index: 1) # San Francisco
  end

  it "user can view server side validations" do
    stub_const("PhotosController::MAX_FILE_UPLOAD_COUNT", 2)

    visit new_photo_path

    expect do
      # Upload all 3 files, which exceeds the 2 file maximum
      upload_file(@filepaths)
      wait_for { page.find(".file-uploader__file-error").text.present? }
    end.to_not(change { Photo.count })

    expect(page.find(".file-uploader__file-error").text).
      to eq(t("components.file_uploader.validator.count", count: 2))
    expect(page).to_not have_selector(".file-uploader__upload-list")
  end

  it "user can view server side validations" do
    visit new_photo_path

    # Upload a file
    expect do
      upload_file(@filepaths[0])
      wait_for_upload_completion(file_index: 0)
    end.to(change { Photo.count }.by(1))

    # Upload the same file - expect that we get a duplication error
    expect do
      upload_file(@filepaths[0])
      wait_for_upload_error(file_index: 0)
    end.to_not(change { Photo.count })

    expect_uploaded_photo_with_error(
      error: t("photos.import_service.duplicate_image"),
      file_index: 0
    )
  end

  def upload_file(filepaths)
    # Can't use Capybara's built-in `attach_file` since the input is disabled
    # https://til.hashrocket.com/posts/c790268652-attach-a-file-with-capybara
    find("form input[type='file']", visible: false).set([filepaths].flatten)
  end

  def wait_for_upload_completion(file_index:)
    wait_for do
      upload = page.find("li[data-id='#{file_index}']")
      upload.all(".file-uploader__upload-progress--done").count.positive?
    end
  end

  def wait_for_upload_error(file_index:)
    wait_for do
      upload = page.find("li[data-id='#{file_index}']")
      upload.all(".error").count.positive?
    end
  end

  def tile_path_for(photo)
    PhotoPresenter.new(photo, view: nil).source_file_path(size: :tile)
  end

  def expect_uploaded_photo(photo, file_index:)
    url = tile_path_for(photo)
    upload = page.find("li[data-id='#{file_index}']")

    expect(upload.find(".file-uploader__upload-preview")["style"]).
      to eq("background-image: url(\"#{url}\");")

    expect(upload.find(".file-uploader__upload-progress")["style"]).
      to eq("width: 100%;")
  end

  def expect_uploaded_photo_with_error(error:, file_index:)
    upload = page.find("li[data-id='#{file_index}']")
    expect(upload.find(".error").text).to eq(error)
  end
end
