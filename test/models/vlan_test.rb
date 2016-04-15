require 'test_helper'

class VlanTest < ActiveSupport::TestCase
  setup do
    @vlan = vlans(:one)
  end

  test "vlan with default empty attributes is invalid" do
    vlan = Vlan.new
    assert vlan.invalid?, "should be invalid with all the attributes empty"
    assert vlan.errors[:vlan_number].any?,
           "There're should be errors since the vlan number is blank"
    assert vlan.errors[:vlan_name].any?,
           "There're should be errors since vlan_name is blank"
    assert vlan.errors[:subnet_mask].any?,
           "There're should be errors since subnet_mask is blank"
    assert vlan.errors[:vlan_description].any?,
           "There're should be errors since vlan_description is blank"
    assert vlan.errors[:gateway].any?,
           "There're should be errors since gateway is blank"
    assert vlan.errors[:static_ip_start].any?,
           "There're should be errors since static_ip_start is blank"
    assert vlan.errors[:static_ip_end].any?,
           "There're should be errors since static_ip_end is blank"
  end

  test "vlan is valid" do
    assert @vlan.valid?, "Should be valid"
  end

  test "vlan number must be present (non-blank) and between 1..4096" do
    # A blank number is invalid
    @vlan.vlan_number = nil
    assert_not @vlan.valid?, "Blank vlan_number should be invalid"
    # Any number outside of Range 1..4096 is invalid
    @vlan.vlan_number = -1
    assert_not @vlan.valid?, "Negative vlan_number should be invalid"
    @vlan.vlan_number = 0
    assert_not @vlan.valid?, "0 should be an invalid vlan_number"
    @vlan.vlan_number = 4097
    assert_not @vlan.valid?,
               "Any number outside 1..4096 should be an invalid vlan_number"
    # vlan_nubmer between 1 and 4096 should be valid
    @vlan.vlan_number = 88
    assert @vlan.valid?,
           "Any number within 1..4096 should be an valid vlan_number"
  end

  test "VLAN FK lan_id must be resolved before being saved" do
    assert_not_nil @vlan.lan_id, "The FK of VLAN fixture two should be found"
  end

  # Non-blank netmask test (not unique)
  test "Subnet mask should be non-blank" do
    @vlan.subnet_mask = nil
    assert @vlan.invalid?, "Blank subnet mask should be invalid"
  end

  # Non-blank & unique gateway test
  test "Gateway should be unique and non-blank" do
    # Forces it to be blank (nil)    
    @vlan.gateway = nil
    assert @vlan.invalid?, "VLAN with a blank gateway should be invalid"
    # Forces it to be the gateway of fixture one    
    @vlan.gateway = vlans(:one).gateway
    assert @vlan.invalid?, "VLAN gateway should be unique"
  end

  # Non-blank & unique static_ip_start test
  test "static_ip_start should be unique and non-blank" do
    # Forces it to be blank (nil)    
    @vlan.static_ip_start = nil
    assert @vlan.invalid?, "VLAN with a blank static_ip_start should be invalid"
    # Uniqueness test against fixture two
    @vlan.static_ip_start = vlans(:two).static_ip_start
    assert @vlan.invalid?, "VLAN static_ip_start should be unique"
  end

  # Non-blank & unique static_ip_end tests
  test "static_ip_end should be unique and non-blank" do
    # Forces it to be blank (nil)    
    @vlan.static_ip_end = nil
    assert @vlan.invalid?, "VLAN with a blank static_ip_end should be invalid"
    # Uniqueness test against fixture two
    @vlan.static_ip_end = vlans(:two).static_ip_end
    assert @vlan.invalid?, "VLAN static_ip_end should be unique"
  end
end
