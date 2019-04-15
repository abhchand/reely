module HasSyntheticId
  extend ActiveSupport::Concern

  included do
    validates :synthetic_id, presence: true, uniqueness: true

    before_validation :generate_synthetic_id, on: :create
  end

  def to_param
    synthetic_id
  end

  def generate_synthetic_id
    self[:synthetic_id] ||= loop do
      # TODO: Instead of downcasing, use `base36` after upgrading to Rails 6
      # TODO: Ensure everywhere we find by `synthetic_id` that `downcase` the
      # search string first
      token = SecureRandom.base58(28).downcase
      break token unless self.class.exists?(synthetic_id: token)
    end
  end
end
