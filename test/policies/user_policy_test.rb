require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  def test_index
    users = User.all
    assert UserPolicy.new(@tom, users).index?
    assert UserPolicy.new(@jerry, users).index?
    assert UserPolicy.new(@mary, users).index?
    assert UserPolicy.new(@barack, users).index?
    assert UserPolicy.new(@michelle, users).index?
    assert_not UserPolicy.new(@hillary, users).index?
  end

  def test_show
    user = users(:one)
    assert UserPolicy.new(@tom, user).show?
    assert UserPolicy.new(@jerry, user).show?
    assert UserPolicy.new(@mary, user).show?
    assert UserPolicy.new(@barack, user).show?
    assert UserPolicy.new(@michelle, user).show?
    assert_not UserPolicy.new(@hillary, user).show?
  end

  def test_create
    user = User.new
    assert UserPolicy.new(@tom, user).create?
    assert UserPolicy.new(@jerry, user).create?
    assert UserPolicy.new(@mary, user).create?
    assert_not UserPolicy.new(@barack, user).create?
    assert_not UserPolicy.new(@michelle, user).create?
    assert_not UserPolicy.new(@hillary, user).create?
  end

  def test_new
    test_create
  end

  def test_update
    user = users(:one)
    assert UserPolicy.new(@tom, user).update?
    assert UserPolicy.new(@jerry, user).update?
    assert UserPolicy.new(@mary, user).update?
    assert UserPolicy.new(@barack, user).update?
    assert_not UserPolicy.new(@michelle, user).update?
    assert_not UserPolicy.new(@hillary, user).update?
  end

  def test_edit
    test_update
  end

  def test_destroy
    user = users(:one)
    assert UserPolicy.new(@tom, user).destroy?
    assert_not UserPolicy.new(@jerry, user).destroy?
    assert_not UserPolicy.new(@mary, user).destroy?
    assert_not UserPolicy.new(@barack, user).destroy?
    assert_not UserPolicy.new(@michelle, user).destroy?
    assert_not UserPolicy.new(@hillary, user).destroy?
  end

  def test_scope
  end
end
