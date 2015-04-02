module UsersHelper
  def find_department_name(department_id)
    Department.find(department_id).dept_name
  end
end
