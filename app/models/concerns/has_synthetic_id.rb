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
      token = SecureRandom.base58(10)
      break token unless self.class.exists?(synthetic_id: token)
    end
  end
end
