class CreateVlans < ActiveRecord::Migration
  def change
    create_table :vlans do |t|
      t.integer :vlan_number
      t.string :vlan_name
      t.string :subnet_mask
      t.string :gateway
      t.string :static_ip_start
      t.string :static_ip_end
      t.text :vlan_description
      t.references :lan, index: true

      t.timestamps
    end
  end
end
