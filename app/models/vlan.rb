class Vlan < ActiveRecord::Base
  require 'csv'

  belongs_to :lan
  has_many :addresses, dependent: :destroy
  has_many :reserved_addresses, dependent: :destroy
  has_many :users, through: :addresses

  # See http://richonrails.com/articles/importing-csv-files
  # Import a csv file into table vlans
  # Check to see if the VLAN already exists in the database. if it does,
  # it will then attempt to update the existing VLAN. If not, 
  # it will attempt to create a new VLAN.
  #def self.import(file, lan_id)
  def self.import(file)
    CSV.foreach(file, headers: true) do |row|
      vlan_hash = row.to_hash
      #vlan_hash[:lan_id] = lan_id # append the lan_id FK
      vlan = Vlan.where(id: vlan_hash["id"])

      if vlan.count == 1
        vlan.first.update_attributes(vlan_hash)
      else
        Vlan.create!(vlan_hash)
      end
    end
  end
end

