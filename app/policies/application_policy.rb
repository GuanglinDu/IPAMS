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

  # Role nobody can do nothing
  def index?
    not system_user.nobody?
  end

  def show?
    #scope.where(:id => record.id).exists?
    not system_user.nobody?
  end

  # Only an expert or an administrator can create/update/edit 
  def create?
    system_user.expert? or system_user.admin?
  end

  def new?
    create?
  end

  def update?
    create? 
  end

  def edit?
    update?
  end

  # Only admin can destroy
  def destroy?
    system_user.admin?
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

