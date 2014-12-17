class RemoveDepartmentFromAddresses < ActiveRecord::Migration
  def change
    remove_reference :addresses, :department, index: true
  end
end
