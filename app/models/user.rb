class User < ApplicationRecord
  AVATAR_SIZES = {
    thumb: { resize: "75x75" },
    medium: { resize: "200x200" }
  }.freeze

  # rubocop:disable LineLength
  has_many :photos, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner
  has_many :collections, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner

  has_one_attached :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: Rails.configuration.x.email_format

  before_validation :encrypt_password_with_salt
  before_save :lower_email_case
  before_save :strip_email
  # rubocop:enable LineLength

  def name
    [first_name, last_name].join(" ")
  end

  def password=(new_password)
    self[:password] = new_password
    self[:password_salt] = nil
    encrypt_password_with_salt
  end

  def correct_password?(guess)
    BCrypt::Engine.hash_secret(guess, password_salt) == password
  end

  def avatar_path(size: nil)
    unless avatar.attached?
      return "/assets/blank-avatar-#{size&.downcase || :medium}.jpg"
    end

    # Somewhat annoyingly, ActiveStorage only provides URL path helpers on
    # variants or previews, not on ::Blob records themselves. So we have to
    # always generate a variant, even if we aren't applying any transformations.
    transformations = AVATAR_SIZES[size] || {}
    variant = avatar.variant(transformations)

    Rails.application.routes.url_helpers.
      rails_representation_url(variant, only_path: true)
  end

  def owns_collection?(collection)
    collection.owner_id == self[:id]
  end

  private

  def encrypt_password_with_salt
    return if password.blank?
    return if password_salt.present?

    self[:password_salt] = BCrypt::Engine.generate_salt
    self[:password] = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def lower_email_case
    email&.downcase!
  end

  def strip_email
    email&.strip!
  end
end
