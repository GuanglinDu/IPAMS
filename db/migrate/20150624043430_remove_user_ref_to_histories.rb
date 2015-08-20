class RemoveUserRefToHistories < ActiveRecord::Migration
  def change
    remove_reference :histories, :user, index: true
  end
end
