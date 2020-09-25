class PhotoCollection < ApplicationRecord
  belongs_to :photo, inverse_of: :photo_collections
  belongs_to :collection, inverse_of: :photo_collections

  validates :photo, presence: true
  validates :collection, presence: true
  validates :collection_id, uniqueness: { scope: :photo_id }

  before_save :validate_owners_match

  private

  def validate_owners_match
    return if photo.owner_id == collection.owner_id
    errors.add(
      :base,
      "Photo owner #{photo.owner_id} does not match Collection " \
        "owner #{collection.owner_id}"
    )
  end
end
