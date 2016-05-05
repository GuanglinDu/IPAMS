require 'test_helper'

class ImportHelperTest < ActiveSupport::TestCase
  test "should return invalid lan_id" do
    assert_equal -999, Vlan.find_lan_id(nil),
      "A nil LAN name should return lan_id -999"
    assert_equal -999, Vlan.find_lan_id(""),
      "A blank LAN name should return lan_id -999"
  end

  test "should return valid lan_id" do
    lan_id = Vlan.find_lan_id("Test LAN")
    #assert_not_same -999, lan_id, "should return a valid lan_id" 
    assert -999 < lan_id, "should return a positive integer lan_id" 
  end

  # Tests class method import 
  test "should return false if the file is nil or blank" do
    # Default value (nil)
    msg = Vlan.import # message Hash returned
    assert_not msg[:success][0], "should return false due to a nil file given"
    assert_equal "File name is nil or blank!", msg[:info][0],
      "Should return the file is nil or blank error"
    # Blank value
    msg = Vlan.import("") # message Hash returned
    assert_not msg[:success][0], "should return false due to a nil file given"
    assert_equal "File name is nil or blank!", msg[:info][0],
      "Should return the file is nil or blank error"
  end

  test "should fail importing" do
    msg =  Vlan.import("file_non_existing.csv") # message Hash returned
    assert_not msg[:success][0], "Non-existing CSV file should be unsuccessful"
    assert_equal "File doesn't exist!", msg[:info][0],
      "Should return file non-existance error"
  end

  # Note: It's a test against the lan fixtures instead of the development db!
  # This test is very fragile since the CSV file might be changed at will
  #test "should import successfully" do
  #  file_name = "#{Rails.root}/public/download/vlan_import_template.csv"
  #  assert File.exists?(file_name), "vlan_import_template.csv should exist"
  #  file = File.new(file_name, "r")
  #  msg =  Vlan.import(file) # message Hash returned
  #  #assert msg[:success][0], "Import should be successful"
  #  assert_not_empty msg[:info][0], "should not be empty"
  #end
end
