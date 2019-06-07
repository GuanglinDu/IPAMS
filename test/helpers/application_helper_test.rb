require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
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
