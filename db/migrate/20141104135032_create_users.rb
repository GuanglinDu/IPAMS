class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, unique: true
      t.integer :office_phone
      t.integer :cell_phone
      t.string :email
      t.string :building
      t.integer :storey
      t.integer :room
      t.references :department, index: true

      t.timestamps
    end
  end
end
