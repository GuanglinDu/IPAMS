#ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ENV"] = "test"
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

  # 1. Tests the controller with Pundit enabled: http://goo.gl/qsRIVo
  # 2. Signs in a user with Devise: http://goo.gl/djlwAJ
  include Devise::TestHelpers
  # sign_in @tom # Signs the users in in the tests 

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in
  # integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
