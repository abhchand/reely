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

  validate :exif_data_not_nil

  after_commit :process_all_variants

  def taken_at=(val)
    if val.blank?
      self[:taken_at] = nil
      return
    end

    # `taken_at` represents the date and time WITHOUT a timezone, since most
    # EXIF Data does not have timezone information :(
    # However Rails always stores time with a zone, and converts to UTC before
    # storage. To workaround this we parse all dates as if they were UTC so
    # it does not get transformed in any way. When working with this date we
    # will just ignore the time zone.
    val = val.strftime("%Y-%m-%d %H:%M:%S") if val.respond_to?(:strftime)
    self[:taken_at] = Time.find_zone("UTC").parse(val)
  end

  private

  def exif_data_not_nil
    return unless self[:exif_data].nil?
    errors.add(:exif_data, :blank)
  end

  def process_all_variants
    return unless source_file.attached?

    SOURCE_FILE_SIZES.each do |_variant, transformations|
      source_file.variant(transformations).processed
    end
  end
end
