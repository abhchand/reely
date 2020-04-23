class Ability
  include CanCan::Ability

  # Define abilities for any given user
  # Philosphy: keep this as simple as possible
  #
  #   1. Stick with `:read` and `:write` where possible, even if the phrasing
  #      is awkward (e.g. "edit user" sometimes reads better than "write user")
  #
  #   2. Avoid using `:manage` and `:all` where possible. It's a catch-all, and
  #      not a best-practice
  #
  #   3. Define by ability, not by role

  def initialize(user)
    @user = user

    can :read, :admin do
      admin?
    end

    can :write, :admin do
      admin?
    end

    can :read, :mailer_previews do
      admin?
    end

    can :write, :sidekiq do
      admin?
    end

    can :read, :users do
      true
    end

    can :read, User do |u|
      admin? || observer? || manages?(u)
    end

    can :write, User do |_user|
      admin?
    end

    can :write, UserInvitation do |_user_invitation|
      admin?
    end
  end

  private

  def admin?
    @user.has_role?("admin")
  end
end
