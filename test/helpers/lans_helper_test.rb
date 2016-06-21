require 'test_helper'

class LansHelperTest < ActionView::TestCase
  test "should find lan name" do
    lan = lans(:one)
    assert_equal lan.lan_name, find_lan_name(lan.id)
  end

  test "should not find lan name" do
    assert_equal "RecordNotFound", find_lan_name(100)
  end
end
