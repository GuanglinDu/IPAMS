class AddAddressOrderToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address_order, :integer, limit: 3, default: 0
  end
end
