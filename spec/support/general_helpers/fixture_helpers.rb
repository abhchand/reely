module GeneralHelpers
  def fixture_path_for(fixture)
    Pathname.new(fixture_path).join(fixture)
  end

  def attach_photo_fixture(photo:, fixture:)
    file = File.open(fixture_path_for("images/#{fixture}"))
    photo.source_file.attach(io: file, filename: fixture)
  end

  # rubocop:disable Metrics/LineLength
  def create_import_file(owner: nil, synthetic_id: nil, fixture:, target_subpath: nil)
    # rubocop:enable Metrics/LineLength
    namespace = owner&.synthetic_id || synthetic_id

    source_fp = fixture_path_for(fixture)

    target_fp = Pathname.new(import_dir).join(namespace)
    target_fp = target_fp.join(target_subpath) if target_subpath
    target_fp = target_fp.join(source_fp.basename)

    FileUtils.mkdir_p(target_fp.dirname)
    FileUtils.cp(source_fp, target_fp)

    target_fp
  end

  def create_upload_file(fixture:)
    source_fp = fixture_path_for(fixture)
    target_fp = Pathname.new(upload_dir).join(source_fp.basename)

    FileUtils.mkdir_p(target_fp.dirname)
    FileUtils.cp(source_fp, target_fp)

    target_fp
  end

  def strip_and_rewrite_exif_data(filepath:, exif_data:)
    if filepath.to_s.include?(Rails.root.join("spec").to_s)
      raise "Cant modify fixture files inside git repository!"
    end

    # Strip the EXIF data.
    # Note - Exiftool considers some data permanent and does not wipe them
    # with `-all=` (e.g. `File Name`, `MIME Type`, etc..)
    `exiftool -all= #{filepath}`

    tags = []
    exif_data.each do |tag, value|
      # Exiftool is pretty robust at setting the tag name, so just camel-case
      # them blindly and update this logic if any break in the future.
      tags << "-\"#{tag.to_s.camelize}\"='#{value}'"
    end

    `exiftool #{tags.join(" ")} #{filepath}`
  end
end
