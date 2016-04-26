# http://blog.carbonfive.com/2013/10/21/migrating-to-pundit-from-cancan/
# Note: A User is an IP address user, different from an admin
class ApplicationPolicy
  # Admin performing the action &
  # the model instance upon which action is performed
  attr_reader :admin, :record

  def initialize(admin, record)
    @admin = admin
    @record = record
  end

  # Role nobody can do nothing
  def index?
    not admin.nobody?
  end

  def show?
    #scope.where(:id => record.id).exists?
    not admin.nobody?
  end

  # Only an expert or an administrator can create/update/edit 
  def create?
    admin.expert? or admin.admin? or admin.root?
  end

  def new?
    create?
  end

  def update?
    admin.operator? or admin.expert? or admin.admin? or admin.root?
  end

  def edit?
    update?
  end

  # Only the role root can destroy
  def destroy?
    admin.root?
  end

  def scope
    Pundit.policy_scope!(admin, record.class)
  end

  # Returns the system user id
  def admin_id
    @admin.id
  end

  class Scope
    attr_reader :admin, :scope

    def initialize(admin, scope)
      @admin = admin
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
