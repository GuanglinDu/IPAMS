# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Test data for table lans
Lan.delete_all
Lan.create!(:lan_number => 1, :lan_name => "Legacy LAN",
  :lan_description => %{<p>The traditional LAN with 4-C LANs each.</p>})
Lan.create!(:lan_number => 2, :lan_name => "Datacenter LAN",
  :lan_description => %{<p>The new LAN with 1-C LAN each inside the DC building.</p>})

# Test data for table valns

# Test data for table departments

# Test data for table addresses

# Test data for table users


# Test data for table reserved_addresses

# Test data for table histories

