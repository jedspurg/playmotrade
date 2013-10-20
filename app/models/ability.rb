class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    if current_user.catalog_admin?
      can :manage, CatalogPart
      can :manage, CatalogSet
    end

  end
end
