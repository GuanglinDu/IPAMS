class CreateVlans < ActiveRecord::Migration
  def change
    create_table :vlans do |t|
      t.integer :vlan_number, :unique => true
      t.string :vlan_name, :unique => true
      t.text :vlan_description
      t.string :subnet_mask
      t.string :static_ip_start
      t.string :static_ip_end
      t.references :lan, index: true

      t.timestamps
    end
  end
end
