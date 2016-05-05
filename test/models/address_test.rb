require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    @addr = Address.new ip: "10.0.0.100",
                        vlan_id: vlans(:one).id,
                        user_id: users(:one).id
  end

  test "ip address should not be blank" do
    assert @addr.valid?
    @addr.ip = " "
    assert @addr.invalid?
  end

  test "ip address should be unique" do
    @addr.ip = addresses(:two).ip
    assert @addr.invalid?
    @addr.ip = "10.0.0.101"
    assert @addr.valid?
  end
end
