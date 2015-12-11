class AddressPolicy < ApplicationPolicy
  # Only role admin and role root can recycle
  def recycle?
    system_user.admin? or system_user.root?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
