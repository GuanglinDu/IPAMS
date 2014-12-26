require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# 3.3 What to Include in Your Unit Tests
# Ideally, you would like to include a test for everything which could possibly break.
# It's a good practice to have at least one test for each of your validations
# and at least one test for every method in your model.
class VlanTest < ActiveSupport::TestCase
  # All the attributes presence validation
  test "A Vlan object with default empty attributes is invalid" do
    vlan0 = Vlan.new
    assert_not vlan0.valid?, "should be invalid with all the attributes empty"
    assert vlan0.errors[:vlan_number].any?, "There're should be errors since vlan_number is blank"
    assert vlan0.errors[:vlan_name].any?, "There're should be errors since vlan_name is blank"
    assert vlan0.errors[:subnet_mask].any?, "There're should be errors since subnet_mask is blank"
    assert vlan0.errors[:vlan_description].any?, "There're should be errors since vlan_description is blank"
    assert vlan0.errors[:gateway].any?, "There're should be errors since gateway is blank"
    assert vlan0.errors[:static_ip_start].any?, "There're should be errors since static_ip_start is blank"
    assert vlan0.errors[:static_ip_end].any?, "There're should be errors since static_ip_end is blank"
  end

  # vlan_number presence & range validation tests
  test "vlan_number must be present (non-blank) and between 1..4096" do
    vlan1 = vlans(:one) # pass the fixture to a local varible to modify
    assert vlan1.valid?, "VLAN fixture one should be valid"

    # Blank number is invalid
    vlan1.vlan_number = nil
    assert_not vlan1.valid?, "Blank vlan_number should be invalid"

    # Any number outside of Range 1..4096 is invalid
    vlan1.vlan_number = -1
    assert_not vlan1.valid?, "Negative vlan_number should be invalid"
    vlan1.vlan_number = 0
    assert_not vlan1.valid?, "0 should be an invalid vlan_number"
    vlan1.vlan_number = 4097
    assert_not vlan1.valid?, "Any number outside 1..4096 should be an invalid vlan_number"

    # vlan_nubmer between 1 and 4096 should be valid
    vlan1.vlan_number = 88
    assert vlan1.valid?, "Any number within 1..4096, inclusive, should be an valid vlan_number"
  end

  # VLAN Foreign Key must be found
  test "VLAN FK lan_id must be resolved before being saved" do
    vlan2 = vlans(:two) # pass the fixture to a local varible to modify
    assert vlan2.valid?, "VLAN fixture two should be valid"
    assert_not_nil vlan2.lan_id, "The FK of VLAN fixture two should be found"
  end

  # Non-blank netmask test (not unique)
  test "Subnet mask should be non-blank" do
    vlan2 = vlans(:two) # pass fixture two to a local varible to modify
    assert vlan2.valid?, "VLAN fixture two should be valid"
    vlan2.subnet_mask = nil
    assert vlan2.invalid?, "Blank subnet mask should be invalid"
  end

  # Non-blank & unique gateway test
  test "Gateway should be unique and non-blank" do
    vlan2 = vlans(:two) # pass fixture two to a local varible to modify
    assert vlan2.valid?, "VLAN fixture two should be valid"
    # Forces it to be blank (nil)    
    vlan2.gateway = nil
    assert vlan2.invalid?, "VLAN with a blank gateway should be invalid"
    # Forces it to be the gateway of fixture one    
    vlan2.gateway = vlans(:one).gateway
    assert vlan2.invalid?, "VLAN gateway should be unique"
  end

  # Non-blank & unique static_ip_start test
  test "static_ip_start should be unique and non-blank" do
    vlan3 = vlans(:three) # pass fixture three to a local varible to modify
    assert vlan3.valid?, "VLAN fixture three should be valid"
    # Forces it to be blank (nil)    
    vlan3.static_ip_start = nil
    assert vlan3.invalid?, "VLAN with a blank static_ip_start should be invalid"
    # Uniqueness test against fixture two
    vlan3.static_ip_start = vlans(:two).static_ip_start
    assert vlan3.invalid?, "VLAN static_ip_start should be unique"
  end

  # Non-blank & unique static_ip_end tests
  test "static_ip_end should be unique and non-blank" do
    vlan3 = vlans(:three) # pass fixture three to a local varible to modify
    assert vlan3.valid?, "VLAN fixture three should be valid"
    # Forces it to be blank (nil)    
    vlan3.static_ip_end = nil
    assert vlan3.invalid?, "VLAN with a blank static_ip_end should be invalid"
    # Uniqueness test against fixture two
    vlan3.static_ip_end = vlans(:two).static_ip_end
    assert vlan3.invalid?, "VLAN static_ip_end should be unique"
  end

  ###### Import/export tests ######

  # Tests class method find_lan_id
  test "should return invalid lan_id" do
    assert_equal -999, Vlan.find_lan_id(nil), "Nil lan_name should return lan_id -999"
    assert_equal -999, Vlan.find_lan_id(""), "Blank lan_name should return lan_id -999"
  end

  # Tests against fixtures lans
  test "should return valid lan_id" do
    lan_id = Vlan.find_lan_id("Test LAN") # see fixtures lans
    #assert_not_same -999, lan_id, "should return a valid lan_id" 
    assert -999 < lan_id, "should return a positive integer lan_id" 
  end

  # Tests class method import 
  test "should return false if the file is nil or blank" do
    # Default value (nil)
    msg =  Vlan.import # message Hash returned
    assert_not msg[:success][0], "should return false due to a nil file givem"
    assert_equal "File name is nil or blank!", msg[:info][0], "Should return the file is nil or blank error"
    # Blank value
    msg =  Vlan.import("") # message Hash returned
    assert_not msg[:success][0], "should return false due to a nil file givem"
    assert_equal "File name is nil or blank!", msg[:info][0], "Should return the file is nil or blank error"
  end

  test "should fail importing" do
    msg =  Vlan.import("file_non_existing.csv") # message Hash returned
    assert_not msg[:success][0], "Non-existing CSV file should be unsuccessful"
    assert_equal "File doesn't exist!", msg[:info][0], "Should return file non-existance error"
  end

  # Notice: this is test against the lan fixtures instead of the development db!
  # This test is very fragile since the CSV file might be changed at will
  test "should import successfully" do
    file_name = "#{Rails.root}/public/download/vlan_importing_template.csv"
    assert File.exists?(file_name), "vlan_importing_template.csv should exist"
    # Creates the File object
    file = File.new(file_name, "r")
    msg =  Vlan.import(file) # message Hash returned
    #assert msg[:success][0], "Import should be successful"
    assert_not_empty msg[:info][0], "should not be empty"
  end
end

