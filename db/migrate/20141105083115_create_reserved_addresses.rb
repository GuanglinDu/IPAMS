class CreateReservedAddresses < ActiveRecord::Migration
  def change
    create_table :reserved_addresses do |t|
      t.string :ip
      t.text :description
      t.references :vlan, index: true

      t.timestamps
    end
  end
end
