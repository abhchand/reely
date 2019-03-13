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

  private

  def process_all_variants
    return unless source_file.attached?

    SOURCE_FILE_SIZES.each do |_variant, transformations|
      source_file.variant(transformations).processed
    end
  end
end
