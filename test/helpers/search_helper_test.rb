require 'test_helper'

class SearchHelperTest < ActionView::TestCase
  def test_sort_results
    results = [
      lans(:one),
      vlans(:one),
      addresses(:one),
      users(:one),
      departments(:one),
      histories(:one)
    ]

    sort_results results
    assert_equal 6, @sorted.length 
    assert_equal 1, @sorted[:lan].length 
    assert_equal 1, @sorted[:vlan].length 
    assert_equal 1, @sorted[:address].length 
    assert_equal 1, @sorted[:user].length 
    assert_equal 1, @sorted[:department].length 
    assert_equal 1, @sorted[:history].length 
  end

  def test_custom_pluralize
    assert_equal "LAN", custom_pluralize("lan", 1)
    assert_equal "VLAN", custom_pluralize("vlan", 1)
    assert_equal "Department", custom_pluralize("department", 1)
    assert_equal "User", custom_pluralize("user", 1)
    assert_equal "Address", custom_pluralize("address", 1)
    assert_equal "History", custom_pluralize("history", 1)

    assert_equal "LANs", custom_pluralize("lan", 2)
    assert_equal "VLANs", custom_pluralize("vlan", 2)
    assert_equal "Departments", custom_pluralize("department", 2)
    assert_equal "Users", custom_pluralize("user", 2)
    assert_equal "Addresses", custom_pluralize("address", 2)
    assert_equal "Histories", custom_pluralize("history", 2)
  end
end
