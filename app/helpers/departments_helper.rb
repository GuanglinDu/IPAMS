module DepartmentsHelper
  def find_department_name(department_id)
    Department.find(department_id).dept_name
  end

  def find_department(id)
    @department = Department.find(id)
  end
end
