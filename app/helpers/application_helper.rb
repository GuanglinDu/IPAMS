# Puts all the methods globally accessible to views here
require 'helper_utils'

module ApplicationHelper
  include HelperUtils

  # Tables relationship: departments -> users -> addresses
  def find_user(id)
    @user = User.find(id)
  end

  def find_address(id)
    @address = Address.find(id)
  end

  def find_addresses_of_user(user)
    user.addresses
  end

  def find_department_name(department_id)
    Department.find(department_id).dept_name
  end

  def find_department(id)
    @department = Department.find(id)
  end

  # Determines the latest updated_at value from an address record and its parent
  # record user collectively as the addresses#index view is mainly composed of these 2 tables.  
  # The user's parent record department is excluded as only the department name is used. 
  def max_user_address_updated_at(address)
    # The latest address record updated_at value. dt = datetime.
    dt_addr = address.updated_at
    # The latest user record updated_at value
    dt_user = User.find(address.user_id).updated_at 
    # Determines the latest datetime & returns it
    dt_addr = dt_user if dt_user > dt_addr
  end

  # Creates a cache key for an address on the paginated page (The row caching).
  def cache_key_for_address(address)
    updated_at = address.updated_at.try(:utc).try(:to_s, :number)
    #updated_at = max_user_address_updated_at(address).try(:utc).try(:to_s, :number)
    "addresses/#{address.id}-#{updated_at}"
  end

  # Creates a cache key for the addresses on the paginated page of partial
  # addresses/_addresses.html.erb (The table caching). This partial is shared
  # by both vlans/show.html.erb and addresses/index.html.erb.
  # This is error-prone by calling method maximum of a collection since an Array
  # has no such a method, and only an ActiveRecord_Relation has.
  #max_updated_at = addresses.maximum(:updated_at).try(:utc).try(:to_s, :number) 
  # Uses method maximum to the model, instead.

  # http://stackoverflow.com/questions/21767949/rails-caching-a-paginated-collection
  # Caching pagination collections is tricky. The usual trick of
  # using the collection count and max updated_at does mostly not apply!
  def cache_key_for_addresses(caller_name, offset)
    max = max_department_user_address_updated_at
    max_updated_at = max.try(:utc).try(:to_s, :number)
    "addresses/#{caller_name}-#{offset}-#{max_updated_at}"
  end

  # Creates a cache key for an user.
  def cache_key_for_user(address, user)
    updated_at = user.updated_at.try(:utc).try(:to_s, :number)
    "address-#{address.id}-user-#{user.id}-#{updated_at}"
  end

  def integer?(str)
    /\A[+-]?d+\z/ === str
  end
end
