class AddressPolicy < ApplicationPolicy
  # Only role admin and role root can recycle
  def recycle?
    admin.vip? or admin.root?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
