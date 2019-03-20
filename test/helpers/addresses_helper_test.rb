require 'test_helper'

class AddressesHelperTest < ActionView::TestCase
  test "should find address" do
    address = addresses(:one)
    assert_equal address, find_address(address.id) 
  end

  test "should find addresses of a user" do
    user = users(:one)
    assert_equal 1, find_addresses_of_user(user).length
  end

end
