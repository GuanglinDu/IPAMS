require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  test "department name should not be blank" do
    depart = Department.new
    assert depart.invalid?, "A department name should not be blank"
    assert departments(:one).valid?, "Should be valid"
  end

  test "department name should be unique" do
    # Resuses an existing dept_name
    depart = Department.new dept_name: departments(:one).dept_name,
                            location: "Somewhere"
    assert depart.invalid?, "A department name should be unique"
    # Makes it valid
    depart.dept_name = "The Milk Way"
    assert depart.valid?, "Should be valid now"
  end
end
