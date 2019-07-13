module HasShareId
  extend ActiveSupport::Concern

  included do
    validates :share_id, presence: true, uniqueness: true

    before_validation :generate_share_id, on: :create
  end

  def to_param
    share_id
  end

  def generate_share_id
    self[:share_id] ||= loop do
      # TODO: Instead of downcasing, use `base36` after upgrading to Rails 6
      # TODO: Ensure everywhere we find by `share_id` that `downcase` the
      # search string first
      token = SecureRandom.base58(28).downcase
      break token unless self.class.exists?(share_id: token)
    end
  end
end
