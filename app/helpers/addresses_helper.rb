module AddressesHelper
  def find_address(id)
    @address = Address.find(id)
  end

  def find_addresses_of_user(user)
    addresses = user.addresses
  end
end
