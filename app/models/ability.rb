class Ability
  include CanCan::Ability

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

    can :edit, User do |_user|
      admin?
    end

    can :edit, UserInvitation do |_user_invitation|
      admin?
    end
  end

  private

  def admin?
    @user.has_role?("admin")
  end
end
