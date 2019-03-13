module GeneralHelpers
  def attach_photo_fixture(photo:, fixture:)
    file = File.open(Rails.root + "spec/fixtures/images/#{fixture}")
    photo.source_file.attach(io: file, filename: fixture)
  end
end
