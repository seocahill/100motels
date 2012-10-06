class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :god
        can :manage, :all
    elsif user.has_role? :promoter
        can :manage, :all
    else
        can :read, :all
    end
  end
end
