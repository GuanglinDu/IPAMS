class AddMacAddressToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :mac_address, :string
  end
end
