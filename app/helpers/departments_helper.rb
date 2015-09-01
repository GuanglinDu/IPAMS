module DepartmentsHelper
  # Creates a cache key for the Department#index view with pagination.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +offset+:: the offset of the pagination 
  def cache_key_for_departments(caller_name, offset)
    max_updated_at = Department.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "departments/#{caller_name}-#{offset}-#{max_updated_at}"
  end
end
