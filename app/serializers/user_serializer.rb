class UserSerializer < ApplicationSerializer
  set_id :synthetic_id
  attributes :first_name, :last_name, :email, :last_sign_in_at

  attributes :avatar_paths do |user, _params|
    u = user
    u = UserPresenter.new(u, view: nil) if user.is_a?(User)

    {}.tap do |paths|
      ([nil] + User::AVATAR_SIZES.keys).each do |size|
        paths[size || :original] = u.avatar_path(size: size)
      end
    end
  end

  attribute :current_user_abilities do |user, params|
    ability = params[:current_ability]
    next unless ability

    ability.user_abilities_for(user)
  end

  # Below attributes are only available when the `user` is wrapped in
  # a `UserPresenter`
  attributes :roles, if: proc { |user, _params| user.respond_to?(:roles) }

  link :self do |user, _params|
    Rails.application.routes.url_helpers.api_v1_user_url(user)
  end
end
