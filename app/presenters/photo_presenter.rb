class PhotoPresenter < ApplicationPresenter
  def source_file_path(size: nil)
    opts = { id: direct_access_key }
    opts[:size] = size if Photo::SOURCE_FILE_SIZES.key?(size)

    # See documentation in `Photos::SourceFileController` on why we generate
    # this custom route to serve the file instead of the service URL provided
    # by ActiveStorage
    photos_source_file_path(opts)
  end

  def taken_at_label
    I18n.l(taken_at, format: :month_and_year)
  end

  def photo_grid_props
    {
      id: synthetic_id,
      mediumUrl: source_file_path(size: :medium),
      url: source_file_path,
      takenAtLabel: taken_at_label
    }
  end
end
