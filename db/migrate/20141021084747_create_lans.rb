class CreateLans < ActiveRecord::Migration
  def change
    create_table :lans do |t|
      t.integer :lan_number
      t.string :lan_name
      t.text :lan_description

      t.timestamps
    end
  end
end
