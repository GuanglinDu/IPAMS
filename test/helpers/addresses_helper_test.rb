require 'test_helper'

class AddressesHelperTest < ActionView::TestCase
  test "should find address" do
    address = addresses(:one)
    assert_equal address, AddressesHelper.find_address(address.id)
  end
end
