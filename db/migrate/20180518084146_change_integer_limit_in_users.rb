class ChangeIntegerLimitInUsers < ActiveRecord::Migration
  def change
    change_column :users, :office_phone, :integer, limit: 8
    change_column :users, :cell_phone,   :integer, limit: 8
  end
end
