class Collection < ApplicationRecord
  include HasSyntheticId
  include HasShareId

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  has_many :photo_collections, inverse_of: :collection, dependent: :destroy
  has_many :photos, through: :photo_collections

  validates :name, presence: true

  def as_json(_options = {})
    super(only: %i[id owner_id name]).tap do |obj|
      # Only ever expose the `synthetic_id` externally
      obj["id"] = synthetic_id
    end
  end

  def share_path
    Rails.application.routes.url_helpers.shared_collection_path(
      id: self[:share_id]
    )
  end

  def cover_photos
    @cover_photos ||= photos.order(:created_at).first(4)
  end

  def accessibility
    { share_path: share_path }
  end
end
