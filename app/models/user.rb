class User < ApplicationRecord
  AVATAR_SIZES = {
    thumb: { resize: "75x75" },
    medium: { resize: "200x200" }
  }.freeze

  OMNIAUTH_PROVIDERS = %w[google_oauth2].freeze

  devise :database_authenticatable, :confirmable,
         :recoverable, :registerable, :timeoutable, :trackable,
         :validatable, :omniauthable, omniauth_providers: OMNIAUTH_PROVIDERS

  rolify

  include HasSyntheticId

  # rubocop:disable LineLength
  has_many :photos, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner
  has_many :collections, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner
  has_many :shared_collection_recipients, dependent: :destroy, inverse_of: :recipient
  has_many :received_collections, through: :shared_collection_recipients, source: :collection

  has_one_attached :avatar

  # NOTE: Devise `authenticatable:`, `:database_authenticatable`,
  # `:validatable`, `::confirmable`, and `:recoverable` modules add other
  # validations for fields, particularly :email and :password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :sign_in_count, presence: true
  validates :provider, inclusion: { in: OMNIAUTH_PROVIDERS }, allow_blank: true

  with_options if: :native? do |native|
    native.validates :encrypted_password, presence: true
    native.validates :uid, absence: true

    native.validate :additional_password_requirements
    native.validate :encrypted_password_is_valid_bcrypt_hash
  end

  with_options if: :omniauth? do |omniauth|
    omniauth.validates :password, absence: true
    omniauth.validates :encrypted_password, absence: true
    omniauth.validates :reset_password_token, absence: true
    omniauth.validates :reset_password_sent_at, absence: true
    omniauth.validates :confirmation_token, absence: true
    omniauth.validates :confirmed_at, absence: true
    omniauth.validates :confirmation_sent_at, absence: true
    omniauth.validates :uid, presence: true, uniqueness: { case_sensitive: false }
  end

  # Override default Devise behavior. We want to skip sending confirmation for
  # omniauth logins since we assume the third party service has already
  # verified this.
  after_create :skip_confirmation_notification!, if: :omniauth?

  # rubocop:enable LineLength

  # Override Devise's implementation of this method which relies on
  # enqueuing mailers through ActiveJob. Below uses Sidekiq's ActionMailer
  # extensions (e.g. `delay`) instead.
  def send_devise_notification(notification, *args)
    devise_mailer.delay.send(notification, self, *args)
  end

  # Override Devise's implementation of this method which blindly sends
  # reset password emails to all auth types. We should never attempt to send
  # a password reset to an omniauth account, and if we do we want to flag it
  # as a validation error so that the subsequent response can display it
  # in a flash or auth error.
  def send_reset_password_instructions
    if omniauth?
      provider = User.human_attribute_name("omniauth_provider.#{self.provider}")
      errors.add(:base, :omniauth_not_recoverable, provider: provider)
    else
      super
    end
  end

  def native?
    provider.blank?
  end

  def omniauth?
    provider.present?
  end

  # Override Devise's logic that checks if a user is `:confirmed`.
  # We assume any omniauth record has already been confirmed by the third
  # party service.
  def confirmed?
    omniauth? || super
  end

  def name
    [first_name, last_name].join(" ")
  end

  def name=(full_name)
    self[:first_name], self[:last_name] = full_name.split(" ", 2)
  end

  def owns_collection?(collection)
    collection.owner_id == self[:id]
  end

  private

  # Override Devise check in `:validatable` module
  # We only want to check password presence and confirmation for native auth
  def password_required?
    native? && super
  end

  def additional_password_requirements
    # `password` contains the raw password and is a synthetic field only set by
    # Devise when using the `password=` setter.
    return if password.blank?

    # Also check length validation in `Devise.password_length`
    valid = [/.{6,}/, /[0-9]/, /[a-zA-Z]/, /[!#$%&]/].all? { |p| password =~ p }
    return if valid

    errors.add(:password, :invalid).tap do
      # Devise already implements other `:password` validations and we want
      # this to supercede those, especially the length validation since we
      # check that here ourselves. Ensure our message is added first
      errors.details[:password].reverse!
      errors.messages[:password].reverse!
    end
  end

  def encrypted_password_is_valid_bcrypt_hash
    ::BCrypt::Password.new(encrypted_password)
  rescue BCrypt::Errors::InvalidHash
    errors.add(:encrypted_password, :invalid)
  end
end
