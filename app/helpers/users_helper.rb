module UsersHelper
  def find_department_name(department_id)
    dept_name = Department.find(department_id)
  end
end
