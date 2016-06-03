require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user name should not be blank" do
    user = User.new
    assert_not user.valid?, "Should be invalid"
    assert user.errors.any?, "There should be errors"
    user.name = "Barack Obama"
    assert user.valid?, "Should be valid"
    assert_not user.errors.any?, "There should not be errors"
  end

  test "user name should be unique" do
    user = User.new name: users(:one).name, department_id: departments(:one).id
    assert_not user.valid?, "Should be invalid"
    user.name = "Barack Obama"
    assert user.valid?, "Should be valid"
  end
end
