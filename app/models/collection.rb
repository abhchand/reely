class Collection < ApplicationRecord
  include HasSyntheticId

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  has_many :photo_collections, inverse_of: :collection, dependent: :destroy
  has_many :photos, through: :photo_collections

  validates :name, presence: true

  def as_json(_options = {})
    super(only: %i[synthetic_id owner_id name])
  end

  def cover_photos
    @cover_photos ||= photos.order(:created_at).first(4)
  end
end
