class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user.present?

      if current_user.admin?
        can :manage, :all
      else
        can :read, :all
      end

      if current_user.catalog_admin?
        can :manage, CatalogPart
        can :manage, CatalogSet
      end

      if current_user.store.present?
        can :manage, Store, :user_id => current_user.id
      end

    end

  end
end
