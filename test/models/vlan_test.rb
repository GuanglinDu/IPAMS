require 'test_helper'

class VlanTest < ActiveSupport::TestCase
  test "A Vlan object with default empty attributes is invalid" do
    vlan = Vlan.new
    assert_not vlan.valid?, "should be invalid with all the attributes empty"
  end

  # vlan_number validation tests
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

  # Non-black netmask test (not unique)
  test "Subnet mask should be non-blank" do
    vlan2 = vlans(:two) # pass the fixture to a local varible to modify
    vlan2.subnet_mask = nil
    assert vlan2.invalid?, "Bland subnet mask should be invalid"
  end

  # Non-blank & unique gateway tests
  # Non-blank & unique static_ip_start tests
  # Non-blank & unique static_ip_end tests
end
