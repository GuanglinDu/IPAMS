module AddressesHelper
  def find_address(id)
    Address.find(id)
  end

  def find_addresses_of_user(user)
    user.addresses
  end
end
