class AddAssignerToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :assigner, :string
  end
end
