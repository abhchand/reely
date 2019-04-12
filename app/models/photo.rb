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
  validate :lat_long_both_blank_or_present

  before_validation :default_taken_at, on: :create
  before_validation :default_lat_long, on: :create
  after_commit :process_all_variants

  def taken_at=(val)
    # `taken_at` represents the date and time WITHOUT a timezone, since most
    # EXIF Data does not have timezone information :(
    # However Rails always stores time with a zone, and converts to UTC before
    # storage. To workaround this we parse all dates as if they were UTC so
    # it does not get transformed in any way. When working with this date we
    # will just ignore the time zone.

    val = val.strftime("%Y-%m-%d %H:%M:%S") if val.respond_to?(:strftime)
    val = (val || "").match(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}/).try(:[], 0)

    if val.blank?
      self[:taken_at] = nil
      return
    end

    self[:taken_at] = Time.find_zone("UTC").parse(val)
  end

  private

  def lat_long_both_blank_or_present
    return if latitude.present? && longitude.present?
    return if latitude.blank? && longitude.blank?

    errors.add(:base, "latitude and longitude must both be present or blank")
  end

  def default_taken_at
    return if taken_at.present?

    # Exiftool gem behavior:
    #
    # `DateTimeOriginal` and `CreateDate` will only ever return `String` with
    # `YYYY:MM:DD HH:MM:SS` format and do not support any timezone info.
    #
    # However `GPSDateTime` supports an optional timezone. If tz present, the
    # exiftool gem returns a `Time` object. If not, a `String` object.
    #
    date =
      exif_data["date_time_original"] ||
      exif_data["create_date"] ||
      exif_data["gps_date_time"] ||
      ActiveSupport::TimeZone["UTC"].now.strftime("%Y:%m:%d %H:%M:%S")

    if date.is_a?(String)
      # Convert `YYYY:MM:DD HH:MM:SS` -> `YYYY-MM-DD HH:MM:SS`
      date = date.split(" ")
      date.first.tr!(":", "-")
      date = date.join(" ")
    end

    self.taken_at = date
  end

  def default_lat_long
    return if latitude.present? && longitude.present?

    # The exiftool gem always returns lat/long with correct sign if a direction
    # (N, S, E, W) is present. Otherwise it just returns whatever value it has.
    #
    # Assume whatever it returns is correct. EXIF writers may not do much
    # validation when writing the data (e.g. you could have -99.00 N latitude).
    #
    lat = exif_data["gps_latitude"]
    long = exif_data["gps_longitude"]

    return if lat.blank? || long.blank?

    self[:latitude] = lat
    self[:longitude] = long
  end

  def process_all_variants
    return unless source_file.attached?

    SOURCE_FILE_SIZES.each do |_variant, transformations|
      source_file.variant(transformations).processed
    end
  end
end
