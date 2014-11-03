# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Test data for table lans
Vlan.delete_all
Lan.delete_all

lan1 = Lan.create!(:lan_number => 1, :lan_name => "Legacy LAN",
  :lan_description => %{<p>The traditional LAN with 4-C LANs each.</p>})
lan2 = Lan.create!(:lan_number => 2, :lan_name => "Datacenter LAN",
  :lan_description => %{<p>The new LAN with 1-C LAN each inside the DC building.</p>})

# Test data for table valns
vlan11_of_lan1 = Vlan.create!(lan_id: lan1.id, vlan_number: 11, vlan_name: "VLAN_11", subnet_mask: "255.255.255.0",
  gateway: "192.168.0.254", static_ip_start: "192.168.0.0", static_ip_end: "192.168.0.255", 
  vlan_description: "Storey 1 of the Main Buiding")
vlan12_of_lan1 = Vlan.create!(lan_id: lan1.id, vlan_number: 12, vlan_name: "VLAN_12", subnet_mask: "255.255.255.0",
  gateway: "192.168.1.254", static_ip_start: "192.168.1.0", static_ip_end: "192.168.1.255", 
  vlan_description: "Storey 2 of the Main Buiding")

vlan21_of_lan2 = Vlan.create!(lan_id: lan2.id, vlan_number: 21, vlan_name: "VLAN_21", subnet_mask: "255.255.255.0",
  gateway: "192.168.2.254", static_ip_start: "192.168.2.0", static_ip_end: "192.168.2.255", 
  vlan_description: "Storey 1 of Buiding DC")
vlan22_of_lan2 = Vlan.create!(lan_id: lan2.id, vlan_number: 22, vlan_name: "VLAN_22", subnet_mask: "255.255.255.0",
  gateway: "192.168.3.254", static_ip_start: "192.168.3.0", static_ip_end: "192.168.3.255", 
  vlan_description: "Storey 2 of Buiding DC")

# Test data for table departments

# Test data for table addresses

# Test data for table users


# Test data for table reserved_addresses

# Test data for table histories

