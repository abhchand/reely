class Collection < ApplicationRecord
  include HasSyntheticId
  include HasShareId

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  # rubocop:disable LineLength
  has_many :photo_collections, inverse_of: :collection, dependent: :destroy
  has_many :photos, through: :photo_collections
  has_many :shared_collection_recipients, dependent: :destroy, inverse_of: :collection
  has_many :sharing_recipients, through: :shared_collection_recipients, source: :recipient
  # rubocop:enable LineLength

  validates :name, presence: true

  validate do |collection|
    if collection[:sharing_config].nil?
      collection.errors.add(:sharing_config, :nil)
    end
  end

  def as_json(_options = {})
    super(only: %i[id owner_id name]).tap do |obj|
      # Only ever expose the `synthetic_id` externally
      obj["id"] = synthetic_id
    end
  end

  def cover_photos
    @cover_photos ||= photos.order(:created_at).first(4)
  end
end
