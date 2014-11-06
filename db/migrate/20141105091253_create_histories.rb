class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.text :usage
      t.datetime :start_date, unique: true
      t.datetime :end_date, unique: true
      t.string :application_form
      t.references :address, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
