class AddRoleToSystemUsers < ActiveRecord::Migration
  def change
    add_column :system_users, :role, :integer, default: 0
  end
end
