class ChangeIntegerLimitInHistories < ActiveRecord::Migration
  def change
    change_column :histories, :office_phone, :integer, limit: 8
    change_column :histories, :cell_phone,   :integer, limit: 8
  end
end
