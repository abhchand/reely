class PhotoPresenter < ApplicationPresenter
  def source_file_path(size: nil)
    opts = { id: direct_access_key }
    opts[:size] = size if Photo::SOURCE_FILE_SIZES.key?(size)

    # See documentation in `RawPhotosController` on why we generate
    # this custom route to serve the file instead of the service URL provided
    # by ActiveStorage
    raw_photo_path(opts)
  end

  def taken_at_label
    I18n.l(taken_at, format: :month_and_year)
  end

  def photo_manager_props
    {
      id: synthetic_id,
      mediumUrl: source_file_path(size: :medium),
      url: source_file_path(size: :screen),
      takenAtLabel: taken_at_label,
      rotate: clockwise_rotation
    }
  end

  private

  def clockwise_rotation
    # See: https://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html
    # TODO: Support horizontal and vertical mirroring options
    case exif_data["orientation"]&.strip&.downcase
    when "horizontal (normal)"  then 0
    when "rotate 180"           then 180
    when "rotate 90 cw"         then 90
    when "rotate 270 cw"        then 270
    else
      0
    end
  end
end
