class RenameSystemUserToAdmin < ActiveRecord::Migration
  def change
    rename_table :system_users, :admins
  end
end
