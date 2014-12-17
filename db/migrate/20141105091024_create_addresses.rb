class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :ip, unique: true
      t.text :usage
      t.datetime :start_date
      t.datetime :end_date
      t.string :application_form
      t.references :vlan, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
