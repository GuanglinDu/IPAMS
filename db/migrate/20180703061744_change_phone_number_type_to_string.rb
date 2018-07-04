class ChangePhoneNumberTypeToString < ActiveRecord::Migration
  def change
    change_column :users,     :office_phone, :string 
    change_column :users,     :cell_phone,   :string 
    change_column :histories, :office_phone, :string 
    change_column :histories, :cell_phone,   :string 
  end
end
