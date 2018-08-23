class ChangeRoomNumberToStringInUsers < ActiveRecord::Migration
  def change
    change_column :users, :room, :string
  end
end
