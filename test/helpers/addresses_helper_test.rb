require 'test_helper'

class AddressesHelperTest < ActionView::TestCase
  setup do
    @address = addresses(:one)    
  end

  test "should find address" do
    assert_equal @address, AddressesHelper.find_address(@address.id)
  end

  test "should find nobody id" do
    id = AddressesHelper.find_nobody_id
    assert id.is_a?(Integer)
  end

  test "should find vlan number" do
    vlan_number = AddressesHelper.find_vlan_number(@address)
    assert_equal 1, vlan_number, "VLAN number should be 1"
  end
end
