require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "should find user" do
    user = users(:one)
    assert_equal user, UsersHelper.find_user(user.id) 
  end
end
