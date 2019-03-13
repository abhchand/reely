class UserPresenter < ApplicationPresenter
  def avatar_path(size: nil)
    unless avatar.attached?
      return "/assets/blank-avatar-#{size&.downcase || :medium}.jpg"
    end

    # Somewhat annoyingly, ActiveStorage only provides URL path helpers on
    # variants or previews, not on ::Blob records themselves. So we have to
    # always generate a variant, even if we aren't applying any transformations.
    # This is fine since avatars are small and only used once per user.
    transformations = User::AVATAR_SIZES[size] || {}
    variant = avatar.variant(transformations)

    rails_representation_url(variant, only_path: true)
  end
end
