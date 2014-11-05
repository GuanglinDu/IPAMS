class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :ip
      t.text :usage
      t.datetime :start_date
      t.datetime :end_date
      t.text :application_form
      t.references :vlan, index: true
      t.references :department, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
