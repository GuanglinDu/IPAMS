require 'test_helper'

class AddressPolicyTest < ActiveSupport::TestCase
  def test_index
    addresses = Address.all
    assert AddressPolicy.new(@tom, addresses).index?
    assert AddressPolicy.new(@jerry, addresses).index?
    assert AddressPolicy.new(@mary, addresses).index?
    assert AddressPolicy.new(@barack, addresses).index?
    assert AddressPolicy.new(@michelle, addresses).index?
    assert_not AddressPolicy.new(@hillary, addresses).index?
  end

  def test_show
    address = addresses(:one)
    assert AddressPolicy.new(@tom, address).show?
    assert AddressPolicy.new(@jerry, address).show?
    assert AddressPolicy.new(@mary, address).show?
    assert AddressPolicy.new(@barack, address).show?
    assert AddressPolicy.new(@michelle, address).show?
    assert_not AddressPolicy.new(@hillary, address).show?
  end

  def test_update
    address = addresses(:one)
    assert AddressPolicy.new(@tom, address).update?
    assert AddressPolicy.new(@jerry, address).update?
    assert AddressPolicy.new(@mary, address).update?
    assert AddressPolicy.new(@barack, address).update?
    assert_not AddressPolicy.new(@michelle, address).update?
    assert_not AddressPolicy.new(@hillary, address).update?
  end

  def test_destroy
    address = addresses(:one)
    assert AddressPolicy.new(@tom, address).destroy?
    assert_not AddressPolicy.new(@jerry, address).destroy?
    assert_not AddressPolicy.new(@mary, address).destroy?
    assert_not AddressPolicy.new(@barack, address).destroy?
    assert_not AddressPolicy.new(@michelle, address).destroy?
    assert_not AddressPolicy.new(@hillary, address).destroy?
  end

  def test_recycle
    address = addresses(:one)
    assert AddressPolicy.new(@tom, address).recycle?
    assert AddressPolicy.new(@jerry, address).recycle?
    assert_not AddressPolicy.new(@mary, address).recycle?
    assert_not AddressPolicy.new(@barack, address).recycle?
    assert_not AddressPolicy.new(@michelle, address).recycle?
    assert_not AddressPolicy.new(@hillary, address).recycle?
  end

  def test_scope
  end
end
