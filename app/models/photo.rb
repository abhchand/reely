class Photo < ApplicationRecord
  include HasSyntheticId
  include HasDirectAccessKey

  SOURCE_FILE_SIZES = {
    thumb: { resize: "75x75" },
    medium: { resize: "200x200" }
  }.freeze

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  has_many :photo_collections, inverse_of: :photo, dependent: :destroy
  has_many :collections, through: :photo_collections

  has_one_attached :source_file

  validates :taken_at, presence: true
  validates :width, presence: true
  validates :height, presence: true

  after_commit :process_all_variants

  def taken_at_display_label
    I18n.l(taken_at, format: :month_and_year)
  end

  def to_photo_grid_react_props
    {
      id: synthetic_id,
      mediumUrl: source_file_path(size: :medium),
      url: source_file_path,
      takenAtLabel: taken_at_display_label
    }
  end

  # Bypass ActiveStorage URL logic and generate a custom Reely path that
  # points to `Photos::SourceFileController`. See documentation in that
  # controller for reasoning behind why we bypass ActiveStorage logic
  def source_file_path(size: nil)
    opts = { id: direct_access_key }
    opts[:size] = size if SOURCE_FILE_SIZES.key?(size)

    Rails.application.routes.url_helpers.photos_source_file_path(opts)
  end

  private

  def process_all_variants
    return unless source_file.attached?

    SOURCE_FILE_SIZES.each do |_variant, transformations|
      source_file.variant(transformations).processed
    end
  end
end
