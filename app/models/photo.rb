class Photo < ActiveRecord::Base
  include HasSyntheticId

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  has_many :photo_collections, inverse_of: :photo, dependent: :destroy
  has_many :collections, through: :photo_collections

  has_attached_file(
    :source,
    styles: { medium: "200x200>", thumb: "75x75>" }
  )

  validates :taken_at, presence: true
  validates :width, presence: true
  validates :height, presence: true

  validates_attachment(
    :source,
    presence: true,
    content_type: { content_type: %r{\Aimage\/.*\Z} }
  )

  def taken_at_display_label
    I18n.l(taken_at, format: :month_and_year)
  end

  def to_photo_grid_react_props
    {
      id: synthetic_id,
      mediumUrl: source.url(:medium),
      url: source.url,
      takenAtLabel: taken_at_display_label
    }
  end
end
