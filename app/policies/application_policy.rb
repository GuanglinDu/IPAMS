# Note: A User is an IP address user while a sys_user is a SystemUser
class ApplicationPolicy
  attr_reader :sys_user, :record

  def initialize(sys_user, record)
    @sys_user = sys_user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(sys_user, record.class)
  end

  class Scope
    attr_reader :sys_user, :scope

    def initialize(sys_user, scope)
      @sys_user = sys_user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end

