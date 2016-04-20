require 'test_helper'

class VlanTest < ActiveSupport::TestCase
  setup do
    @vlan = vlans(:one)
    @test_vlan = Vlan.new vlan_number: 200,
                          vlan_name: "some_name",
                          vlan_description: "A VLAN for test",
                          gateway: "10.0.200.254",
                          subnet_mask: "255.255.225.0",
                          static_ip_start: "10.0.200.0",
                          static_ip_end: "10.0.200.255",
                          lan_id: lans(:one).id
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

  test "vlans are valid" do
    assert @vlan.valid?, "Should be valid"
    assert @test_vlan.valid?, "Should be valid"
  end

  test "vlan number must be between 1 and 4094" do
    @test_vlan.vlan_number = -1
    assert_not @test_vlan.valid?, "Negative vlan_number should be invalid"
    @test_vlan.vlan_number = 4095
    assert_not @test_vlan.valid?,
               "Any number outside of 1..4094 should be invalid"
  end

  test "gateway should be unique" do
    @test_vlan.gateway = @vlan.gateway
    assert @test_vlan.invalid?, "A VLAN's gateway should be unique"
  end

  test "starting ip address should be unique" do
    @test_vlan.static_ip_start = vlans(:two).static_ip_start
    assert @test_vlan.invalid?, "VLAN's starting ip address should be unique"
  end

  test "end ip address should be unique" do
    @test_vlan.static_ip_end = vlans(:two).static_ip_end
    assert @test_vlan.invalid?, "A VLAN's end ip address should be unique"
  end
end
