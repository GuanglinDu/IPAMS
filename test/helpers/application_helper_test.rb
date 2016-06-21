require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "should find user" do
    user = users(:one)
    assert_equal user, find_user(user.id) 
  end

  test "should find address" do
    address = addresses(:one)
    assert_equal address, find_address(address.id) 
  end

  test "should find department" do
    department = departments(:one)
    assert_equal department, find_department(department.id) 
  end

  test "should find addresses of a user" do
    user = users(:one)
    assert_equal 1, find_addresses_of_user(user).length
  end

  test "should find department name" do
    department = departments(:one)
    assert_equal department.dept_name, find_department_name(department.id) 
  end

  test "should be integers" do
    assert integer?("123")
    assert integer?("012")
  end

  test "should not be integers" do
    assert_not integer?("a12")
    assert_not integer?("34b")
    assert_not integer?(" 12")
    assert_not integer?("3 4")
    assert_not integer?("34 ")
    assert_not integer?("")
    assert_not integer?(" ")
  end
end
