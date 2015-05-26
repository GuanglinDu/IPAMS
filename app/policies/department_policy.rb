class DepartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
