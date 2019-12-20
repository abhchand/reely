class ProductFeedback < ApplicationRecord
  # Should match frontend validation on textarea
  MAX_BODY_LENGTH = 500

  belongs_to :user

  validates :user, presence: true
  validates :body, presence: true, length: { maximum: MAX_BODY_LENGTH }
end
