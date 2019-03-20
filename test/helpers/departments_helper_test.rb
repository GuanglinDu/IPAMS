require 'test_helper'

class DepartmentsHelperTest < ActionView::TestCase
  test "should find department" do
    department = departments(:one)
    assert_equal department, find_department(department.id) 
  end

  test "should find department name" do
    department = departments(:one)
    assert_equal department.dept_name, find_department_name(department.id) 
  end
end
