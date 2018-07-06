class User < ActiveRecord::Base
  has_attached_file(
    :avatar,
    styles: { medium: "200x200#", thumb: "75x75#" }
  )

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: Rails.configuration.x.email_format

  validates_attachment(
    :avatar,
    content_type: { content_type: Rails.configuration.x.allowed_photo_types },
    size: { in: 0..200.kilobytes }
  )

  before_validation :encrypt_password_with_salt
  before_save :lower_email_case
  before_save :strip_email

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

  def avatar_url(size = :thumb)
    if self[:avatar_file_name].present?
      avatar.url(size)
    else
      "/assets/blank-avatar-#{size.to_s.downcase}.jpg"
    end
  end

  private

  def encrypt_password_with_salt
    return if password.blank?
    return if password_salt.present?

    self[:password_salt] = BCrypt::Engine.generate_salt
    self[:password] = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def lower_email_case
    email.downcase! if email
  end

  def strip_email
    email.strip! if email
  end
end
