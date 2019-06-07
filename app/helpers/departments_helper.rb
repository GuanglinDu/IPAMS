module DepartmentsHelper
  def self.find_department(id)
    Department.find(id)
  end

  def self.find_department_name(department_id)
    Department.find(department_id).dept_name
  end

  # Creates a cache key for the Department#index view with pagination.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +offset+:: the offset of the pagination 
  def cache_key_for_departments(caller_name, offset)
    max_updated_at = Department.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "departments/#{caller_name}-#{offset}-#{max_updated_at}"
  end

  # Creates a cache key for a single department (record).
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +department+:: the Department object 
  def cache_key_for_department(caller_name, department)
    updated_at = department.updated_at().try(:utc).try(:to_s, :number)
    "departments/#{caller_name}-#{department.id}-#{updated_at}"
  end
end
