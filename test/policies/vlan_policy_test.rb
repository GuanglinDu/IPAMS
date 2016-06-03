require 'test_helper'

class VlanPolicyTest < ActiveSupport::TestCase
  def test_create
    vlans = Vlan.all
    assert VlanPolicy.new(@tom, vlans).index?
    assert VlanPolicy.new(@jerry, vlans).index?
    assert VlanPolicy.new(@mary, vlans).index?
    assert VlanPolicy.new(@barack, vlans).index?
    assert VlanPolicy.new(@michelle, vlans).index?
    assert_not VlanPolicy.new(@hillary, vlans).index?
  end

  def test_show
    vlans = Vlan.all
    assert VlanPolicy.new(@tom, vlans).show?
    assert VlanPolicy.new(@jerry, vlans).show?
    assert VlanPolicy.new(@mary, vlans).show?
    assert VlanPolicy.new(@barack, vlans).show?
    assert VlanPolicy.new(@michelle, vlans).show?
    assert_not VlanPolicy.new(@hillary, vlans).show?
  end

  def test_create
    vlan = vlans(:one)
    assert VlanPolicy.new(@tom, vlan).create?
    assert VlanPolicy.new(@jerry, vlan).create?
    assert VlanPolicy.new(@mary, vlan).create?
    assert_not VlanPolicy.new(@barack, vlan).create?
    assert_not VlanPolicy.new(@michelle, vlan).create?
    assert_not VlanPolicy.new(@hillary, vlan).create?
  end

  def test_new
    test_create
  end

  def test_update
    vlan = vlans(:one)
    assert VlanPolicy.new(@tom, vlan).update?
    assert VlanPolicy.new(@jerry, vlan).update?
    assert VlanPolicy.new(@mary, vlan).update?
    assert VlanPolicy.new(@barack, vlan).update?
    assert_not VlanPolicy.new(@michelle, vlan).update?
    assert_not VlanPolicy.new(@hillary, vlan).update?
  end

  def test_edit
    test_update
  end

  def test_destroy
    vlan = vlans(:one)
    assert VlanPolicy.new(@tom, vlan).destroy?
    assert_not VlanPolicy.new(@jerry, vlan).destroy?
    assert_not VlanPolicy.new(@mary, vlan).destroy?
    assert_not VlanPolicy.new(@barack, vlan).destroy?
    assert_not VlanPolicy.new(@michelle, vlan).destroy?
    assert_not VlanPolicy.new(@hillary, vlan).destroy?
  end

  def test_scope
  end
end
