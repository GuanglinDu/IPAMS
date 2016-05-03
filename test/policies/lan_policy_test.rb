require 'test_helper'

class LanPolicyTest < ActiveSupport::TestCase
  def test_index
    lans = Lan.all
    assert LanPolicy.new(@tom, lans).index?
    assert LanPolicy.new(@jerry, lans).index?
    assert LanPolicy.new(@mary, lans).index?
    assert LanPolicy.new(@barack, lans).index?
    assert LanPolicy.new(@michelle, lans).index?
    assert_not LanPolicy.new(@hillary, lans).index?
  end

  def test_show
    lans = Lan.all
    assert LanPolicy.new(@tom, lans).show?
    assert LanPolicy.new(@jerry, lans).show?
    assert LanPolicy.new(@mary, lans).show?
    assert LanPolicy.new(@barack, lans).show?
    assert LanPolicy.new(@michelle, lans).show?
    assert_not LanPolicy.new(@hillary, lans).show?
  end

  def test_create
    lan = Lan.new lan_number: 10,
                  lan_name: "LAN-10",
                  lan_description: "This is LAN 10"
    assert LanPolicy.new(@tom, lan).create?
    assert LanPolicy.new(@jerry, lan).create?
    assert LanPolicy.new(@mary, lan).create?
    assert_not LanPolicy.new(@barack, lan).create?
    assert_not LanPolicy.new(@michelle, lan).create?
    assert_not LanPolicy.new(@hillary, lan).create?
  end

  def test_new
    test_create
  end

  def test_update
    lan = lans(:one)
    assert LanPolicy.new(@tom, lan).update?
    assert LanPolicy.new(@jerry, lan).update?
    assert LanPolicy.new(@mary, lan).update?
    assert LanPolicy.new(@barack, lan).update?
    assert_not LanPolicy.new(@michelle, lan).update?
    assert_not LanPolicy.new(@hillary, lan).update?
  end

  def test_edit
    test_update
  end

  def test_destroy
    lan = lans(:one)
    assert LanPolicy.new(@tom, lan).destroy?
    assert_not LanPolicy.new(@jerry, lan).destroy?
    assert_not LanPolicy.new(@mary, lan).destroy?
    assert_not LanPolicy.new(@barack, lan).destroy?
    assert_not LanPolicy.new(@michelle, lan).destroy?
    assert_not LanPolicy.new(@hillary, lan).destroy?
  end

  def test_scope
  end
end
