require 'minitest/autorun'
require 'active_support/all'
require_relative '../../lib/tasks/import_helper'
require_relative '../../lib/tasks/file_helper'

include ImportHelper
include FileHelper

class TestImportHelper < ActiveSupport::TestCase
  def test_output_comparison_result
    old_attr = ["MAC: 000A-EB1A-C822",
                "Usage: PC",
                "User: LiHong",
                "Depart: Lab",
                "Phone: 2356",
                "Building: Main building"]
    new_attr = ["MAC: 000A-23BC-C800",
                "Usage: computer",
                "User: ZhangDan",
                "Depart: Network Center",
                "Phone: 7830",
                "Building: Main building"]
    diff_file = File.open(FileHelper::IMPORT_DIFF, "w")
    
    # Tests method compare_value
    result = compare_value(old_attr[0], new_attr[0])
    assert_equal("<b>MAC: 000A-23BC-C800</b>", result[1], "Should be equal") 
    # Then tests method output_comparison_result
    #assert_output(
  end

  #test "should be true" do
    #assert true
  #end

  def test_strip_whitespace
    raw_row = {one: " 100", two: "hello  ", three: "  world  ", four: nil, five: "     "}
    raw_row[:six] = 123
    row = strip_whitespace(raw_row)
    assert_equal("100", row[:one], "Should be equal")    
    assert_equal("hello", row[:two], "Should be equal")    
    assert_equal("world", row[:three], "Should be equal")    
    assert_nil(row[:four], "Should return nil")    
    #assert_empty(row[:five], "Should be empty") # why 2 assertions?
    assert_equal("", row[:five], "should be equal")

    # Test non-string objects
    assert_instance_of(Fixnum, row[:six], "Should be Fixnum")
    assert_equal(123, row[:six], "Should be equal")
  end 

  private

    # Makes sure diff file 
    # IMPORT_DIFF = "#{Rails.root}/tmp/IMPORT_DIFF.html" 
    def create_diff_file
      diff_file = File.open(IMPORT_DIFF, "w")
    end 
end
