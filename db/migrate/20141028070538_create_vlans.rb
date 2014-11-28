class CreateVlans < ActiveRecord::Migration
  def change
    create_table :vlans do |t|
      t.integer :vlan_number, unique: true
      t.string :vlan_name, unique: true
      t.string :subnet_mask
      t.string :gateway, unique: true
      t.string :static_ip_start, unique: true
      t.string :static_ip_end, unique: true
      t.text :vlan_description
      t.references :lan, index: true

      t.timestamps
    end
  end
end
