class SearchPolicy < ApplicationPolicy
  def search?
    not system_user.nobody?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
