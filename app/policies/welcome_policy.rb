class WelcomePolicy < Struct.new(:system_user, :welcome)

  class Scope < Scope
    def resolve
      scope
    end
  end
end
