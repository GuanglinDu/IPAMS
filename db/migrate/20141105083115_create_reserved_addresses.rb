class CreateReservedAddresses < ActiveRecord::Migration
  def change
    create_table :reserved_addresses do |t|
      t.string :ip, unique: true
      t.text :description
      t.references :vlan, index: true

      t.timestamps
    end
  end
end
