class AddDetailsToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :mac_address, :string
    add_column :histories, :user_name, :string
    add_column :histories, :dept_name, :string
    add_column :histories, :office_phone, :integer
    add_column :histories, :cell_phone, :integer
    add_column :histories, :building, :string
    add_column :histories, :room, :integer
  end
end
