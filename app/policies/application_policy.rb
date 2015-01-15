# http://blog.carbonfive.com/2013/10/21/migrating-to-pundit-from-cancan/
# Note: A User is an IP address user while a sys_user is a SystemUser
class ApplicationPolicy
  # SystemUser performing the action &
  # the model instance upon which action is performed
  attr_reader :system_user, :record

  def initialize(system_user, record)
    @system_user = system_user
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
    Pundit.policy_scope!(system_user, record.class)
  end

  class Scope
    attr_reader :system_user, :scope

    def initialize(system_user, scope)
      @system_user = system_user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end

