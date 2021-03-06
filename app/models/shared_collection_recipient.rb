class SharedCollectionRecipient < ApplicationRecord
  # rubocop:disable Metrics/LineLength
  belongs_to :collection,
             inverse_of: :shared_collection_recipients, validate: false
  belongs_to :recipient,
             class_name: 'User',
             inverse_of: :shared_collection_recipients,
             validate: false
  # rubocop:enable Metrics/LineLength

  validates :collection_id, presence: true
  validates :recipient_id, presence: true, uniqueness: { scope: :collection_id }
end
