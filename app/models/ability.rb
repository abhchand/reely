class Ability
  include CanCan::Ability

  def initialize(user)
    (%w[all] + ALL_ROLES).each do |role|
      send("set_abilities_for_#{role.downcase}") if user.has_role?(role)
    end
  end

  private

  def set_abilities_for_all
  end

  def set_abilities_for_admin
    can :manage, :all
  end
end
