module AddressesHelper
  def find_address(id)
    @address = Address.find(id)
  end
end
