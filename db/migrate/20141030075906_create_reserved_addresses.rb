class CreateReservedAddresses < ActiveRecord::Migration
  def change
    create_table :reserved_addresses do |t|
      t.string :address_reserved
      t.text :reservation_description
      t.references :vlan, index: true

      t.timestamps
    end
  end
end
