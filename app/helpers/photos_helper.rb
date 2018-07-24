module PhotosHelper
  def to_react_props(photo)
    {
      id: photo.synthetic_id,
      mediumUrl: photo.source.url(:medium),
      url: photo.source.url,
      takenAtLabel: photo.taken_at_display_label
    }
  end
end
