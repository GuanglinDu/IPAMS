module AddressesHelper
  def self.find_address(id)
    Address.find(id)
  end
end
