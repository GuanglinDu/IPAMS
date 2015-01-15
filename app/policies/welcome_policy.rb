class WelcomePolicy < Struct.new(:system_user, :welcome)
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
