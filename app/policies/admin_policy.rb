# Only the root can manage admins
class AdminPolicy < ApplicationPolicy
  def index?
    admin.root?
  end

  def show?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
