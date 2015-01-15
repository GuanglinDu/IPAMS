class LanPolicy < ApplicationPolicy
  def index?
     unless system_user.nobody?
       true
     else
       false
     end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
