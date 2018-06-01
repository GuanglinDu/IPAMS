ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"

Minitest::Reporters.use!

# NOTE (Extremely Important!!!):
# Error when sunspot was integrated: Errno::ECONNREFUSED: Connection refused
# Solution: rake sunspot:solr:run RAILS_ENV=test
# See http://goo.gl/QhoR1J
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in
  # integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  private

  # Returns true inside an integration test.
  def integration_test?
    defined? post_via_redirect
  end

  def sign_in_admin(admin)
    post_via_redirect admin_session_path,
                      admin: {email: admin.email, password: admin.password}
    # The following format is OK, too.
         #"admin[email]" => tom.email,
         #"admin[password]" =>tom.password
  end

  # Used by the policy tests
  def setup
    @tom      = admins(:tom)      # root
    @jerry    = admins(:jerry)    # vip
    @mary     = admins(:mary)     # expert
    @barack   = admins(:barack)   # operator
    @michelle = admins(:michelle) # guest
    @hillary  = admins(:hillary)  # nobody
  end
end

# Tests the controller with Pundit enabled: http://goo.gl/qsRIVo

# 1. Signs in a user with Devise: http://goo.gl/djlwAJ
#    See also https://github.com/plataformatec/devise
# 2. See http://goo.gl/hFRmE0
# Devise::TestHelpers provides a facility to test controllers in isolation
# when using ActionController::TestCase allowing you to quickly sign_in or
# sign_out a user. Do not use Devise::TestHelpers in integration tests.
# 3. See also https://goo.gl/exk9Xe
# 4. The following are not available yet in the final release as of May 2016.
# NameError: uninitialized constant Devise::Test?
# include Devise::Test::ControllerHelpers
# include Devise::Test::IntegrationHelpers
class ActionController::TestCase
  include Devise::TestHelpers
  #sign_in @tom # Signs the users in in the tests 
end
