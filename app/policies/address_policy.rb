class AddressPolicy < ApplicationPolicy
  # Only admin can recycle
  def recycle?
    system_user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
