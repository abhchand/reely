class Collection < ActiveRecord::Base
  include HasSyntheticId

  belongs_to :owner, class_name: "User", inverse_of: :photos, validate: false

  has_many :photo_collections, inverse_of: :collection, dependent: :destroy
  has_many :photos, through: :photo_collections

  validates :name, presence: true
end
