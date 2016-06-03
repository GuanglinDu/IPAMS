# encoding: utf-8

# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require_relative 'populate_table'
include PopulateTable

# Stops rake db:seed in the production environment
#if (ENV["RAILS_ENV"] == "production" || ENV["RAILS_ENV"] == "test")
if (Rails.env.production? || Rails.env.test?)
  puts "Running rake db:seed in the production/test environment is forbidden!" \
    "Usage:\n\tbundle exec rake db:seed RAILS_ENV=development"
else
  run
end
