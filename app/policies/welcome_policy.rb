# Headless (no model) policy
class WelcomePolicy < Struct.new(:system_user, :welcome)
  # Any SystemUser can access the welcome page
  def index?
    true
  end

  class Scope < Scope
    def resolve
      if system_user.admin?
        scope.all
      else
        scope.where(system_user.nobody?)
      end
    end
  end
end
