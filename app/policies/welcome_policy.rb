# Headless (no model) policies
class WelcomePolicy < Struct.new(:admin, :welcome)
  # Any Admin can access the welcome page
  def index?
    true
  end

  # Shows the tip that nobody must ask for authorization
  def tip?
    admin.nobody?
  end
end
