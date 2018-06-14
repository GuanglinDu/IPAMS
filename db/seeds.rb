# encoding: utf-8
require_relative 'populate_admins'
require_relative 'populate_lans'
require_relative 'populate_departments'

include PopulateAdmins
include PopulateLans
include PopulateDepartments

# bundle exec rake db:seed forbidden in the production environment
if (Rails.env.production? || Rails.env.test?)
  hint
else
  Address.delete_all
  Vlan.delete_all
  Lan.delete_all
  User.delete_all
  Department.delete_all

  create_admins
  create_lans
  create_vlans Lan.first
  create_departments
  create_users Department.first

  # Creates IP addresses for the 1st VLAN
  name = Vlan.first.vlan_name
  Rake::Task['init:vlan'].invoke(name)
end

def hint
  puts "Running rake db:seed in the production/test environment forbidden!" \
    "Usage:\n\tbundle exec rake db:seed RAILS_ENV=development"
end
