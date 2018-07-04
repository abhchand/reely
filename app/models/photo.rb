class Photo < ActiveRecord::Base
  has_attached_file(
    :source,
    styles: { medium: "200x200>", thumb: "75x75>" }
  )

  validates_attachment(
    :source,
    presence: true,
    content_type: { content_type: %r{\Aimage\/.*\Z} }
  )

  def taken_at_display_label
    if taken_at.present?
      I18n.l(taken_at, format: :month_and_year)
    else
      I18n.t("activerecord.attributes.photo.unknown_taken_at")
    end
  end
end
