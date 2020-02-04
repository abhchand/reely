class UserPresenter < ApplicationPresenter
  include WebpackHelper

  def avatar_path(size: nil)
    raise "Unknown avatar size: #{size}" unless valid_avatar_size?(size)

    unless avatar.attached?
      return image_path("blank-avatar-#{size&.downcase || :medium}.jpg")
    end

    # Somewhat annoyingly, ActiveStorage only provides URL path helpers on
    # variants or previews, not on ::Blob records themselves. So we have to
    # always generate a variant, even if we aren't applying any transformations.
    # This is fine since avatars are small and only used once per user.
    transformations = User::AVATAR_SIZES[size] || {}
    variant = avatar.variant(transformations)

    rails_representation_url(
      variant,
      disposition: "attachment",
      only_path: true
    )
  end

  def roles
    model.roles.map(&:name).sort
  end

  private

  def valid_avatar_size?(size)
    return true if size.nil?
    return true if Rails.env.production?

    User::AVATAR_SIZES.key?(size)
  end
end
