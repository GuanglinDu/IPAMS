class AddRecyclableToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :recyclable, :boolean, :null => false, :default => true
  end
end
