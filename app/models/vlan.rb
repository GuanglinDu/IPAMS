class Vlan < ActiveRecord::Base
  require 'csv'

  validates :vlan_number, :vlan_name, :gateway, :static_ip_start, :static_ip_end, presence: true, uniqueness: true
  validates :vlan_description, presence: true, length: { minimum: 5 }

  belongs_to :lan
  has_many :addresses, dependent: :destroy
  has_many :reserved_addresses, dependent: :destroy
  has_many :users, through: :addresses

  # See http://richonrails.com/articles/importing-csv-files
  # Import a csv file into table vlans
  # Check to see if the VLAN already exists in the database. if it does,
  # it will then attempt to update the existing VLAN. If not, 
  # it will attempt to create a new VLAN.
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      vlan_hash = row.to_hash
      #vlan_hash[:lan_id] = lan_id # append the lan_id FK
      #vlan = Vlan.where(id: vlan_hash["id"])

      if vlan_exists(vlan_hash)
        vlan.first.update_attributes(vlan_hash)
      else
        Vlan.create(vlan_hash)
      end
    end
  end

  # Find FK lan_id with lan_name
  def find_lan_id(lan_name)
  end
  
  # Determines if a VLAN already exists.
  def self.vlan_exists(vlan_hash_to_import = {})
    exist = false
    vlans = Vlan.all # Array
    vlans = vlans.to_a.map(&:serializable_hash) # to Hash
    vlans.each do |vlan|
      t = vlan.delete(:id)
      if t == vlan_hash_to_import
        exist = true
        break
      end 
    end

    return exist  
  end
end

