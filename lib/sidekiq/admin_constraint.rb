module Sidekiq
  class AdminConstraint
    def matches?(request)
      user_id = request.session['warden.user.user.key'].dig(0, 0)

      return false unless user_id
      user = User.find_by_id(user_id)
      user && Ability.new(user).can?(:write, :sidekiq)
    end
  end
end
