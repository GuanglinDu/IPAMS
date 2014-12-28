class CreateSystemUsers < ActiveRecord::Migration
  def change
    create_table :system_users do |t|
      t.string :name
      #t.digest :password
      t.string :password_digest

      t.timestamps
    end
  end
end
