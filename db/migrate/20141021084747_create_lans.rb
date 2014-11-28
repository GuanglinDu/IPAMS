class CreateLans < ActiveRecord::Migration
  def change
    create_table :lans do |t|
      t.integer :lan_number, :unique => true
      t.string :lan_name, :unique => true
      t.text :lan_description

      t.timestamps
    end
  end
end
