class PhotoCollection < ActiveRecord::Base
  belongs_to :photo, inverse_of: :photo_collections
  belongs_to :collection, inverse_of: :photo_collections

  validates :photo, presence: true
  validates :collection, presence: true
  validates :collection_id, uniqueness: { scope: :photo_id }
end
