module AddressesHelper
  def self.find_address(id)
    Address.find(id)
  end

  def self.find_nobody_id()
    nobody_id = User.find_by(name: "NOBODY").id
  end
end
