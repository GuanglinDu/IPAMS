class LanPolicy < ApplicationPolicy
  # Role nobody can do nothing
  def index?
      not system_user.nobody?
  end

  # Only an expert or an administrator can create/update/edit a Lan 
  def create?
    system_user.expert? or system_user.admin?
  end

  def new?
    create?
  end

  def update?
    create? 
  end

  def edit?
    update?
  end

  # Only admin can destroy a Lan
  def destroy?
    system_user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
