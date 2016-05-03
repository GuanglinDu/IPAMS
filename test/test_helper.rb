#ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in
  # integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # All kinds of admins
  def setup
    @tom = admins(:tom)           # root
    @jerry = admins(:jerry)       # admin
    @mary = admins(:mary)         # expert
    @barack = admins(:barack)     # operator
    @michelle = admins(:michelle) # guest
    @hillary = admins(:hillary)   # nobody 
  end
end
