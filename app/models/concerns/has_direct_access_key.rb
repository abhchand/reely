module HasDirectAccessKey
  extend ActiveSupport::Concern

  included do
    validates :direct_access_key, presence: true, uniqueness: true

    before_validation :generate_direct_access_key, on: :create
  end

  def generate_direct_access_key
    self[:direct_access_key] ||= loop do
      token = SecureRandom.base58(28)
      break token unless self.class.exists?(direct_access_key: token)
    end
  end
end
