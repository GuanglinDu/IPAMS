require 'helper_utils'

module UsersHelper
  include HelperUtils

  def find_user(id)
    User.find(id)
  end

  # Creates a cache key for the User#index view with pagination.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +offset+:: the offset of the pagination 
  def cache_key_for_users(caller_name, offset)
    max = max_department_user_address_updated_at
    max_updated_at = max.try(:utc).try(:to_s, :number)
    "users/#{caller_name}-#{offset}-#{max_updated_at}"
  end
end
