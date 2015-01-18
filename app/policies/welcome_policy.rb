# Headless (no model) policies
class WelcomePolicy < Struct.new(:system_user, :welcome)
  # Any SystemUser can access the welcome page
  def index?
    true
  end
end
