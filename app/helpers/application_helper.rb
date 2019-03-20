# Puts all the methods globally accessible to views here
require 'helper_utils'

module ApplicationHelper
  include HelperUtils

  # Determines the latest updated_at value from an address record and its parent
  # record user collectively as the addresses#index view is mainly composed of
  # these 2 tables.  
  # The user's parent record department is excluded as only the department name
  # is used. 
  def max_user_address_updated_at(address)
    # The latest address record updated_at value. dt = datetime.
    dt_addr = address.updated_at
    # The latest user record updated_at value
    dt_user = User.find(address.user_id).updated_at 
    # Determines the latest datetime & returns it
    dt_addr = dt_user if dt_user > dt_addr
  end

  # Creates a cache key for the addresses on the paginated page of partial
  # addresses/_addresses.html.erb (The table caching). This partial is shared
  # by both vlans/show.html.erb and addresses/index.html.erb.
  # This is error-prone by calling method maximum of a collection since an Array
  # has no such a method, and only an ActiveRecord_Relation has.
  #max_updated_at = addresses.maximum(:updated_at).try(:utc).try(:to_s, :number) 
  # Uses method maximum to the model, instead.
  # http://goo.gl/CRtFN1
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

  # http://goo.gl/DXOjbB
  def integer?(str)
    /\A[+-]?\d+\z/ === str
  end
end
