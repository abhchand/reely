module HasShareId
  extend ActiveSupport::Concern

  included do
    validates :share_id, presence: true, uniqueness: true

    before_validation :generate_share_id, on: :create
  end

  def generate_share_id
    self[:share_id] ||= loop do
      token = SecureRandom.base58(10)
      break token unless self.class.exists?(share_id: token)
    end
  end
end
