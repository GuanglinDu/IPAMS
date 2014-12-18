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
  # The VLANs importing CSV template with 1st row as the headers:
  # lan_name   vlan_number vlan_name static_ip_start static_ip_end  subnet_mask   gateway	 vlan_description
  # Legacy LAN 23	   VLAN_23   192.168.23.0    192.168.23.255 255.255.255.0 192.168.23.254 Main Building
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      vhash = row.to_hash # temporary VLAN record hash

      # Find FK lan_id
      vhash[:lan_id] = find_lan_id(vhash[:lan_name]) # append the lan_id FK
      # Remove lan_name field from the row as it's not part of table vlans records
      vhash.delete(:lan_name)
      #vlan = Vlan.where(id: vhash["id"])

      if vlan_exists(vhash)
        vlan.first.update_attributes(vhash)
      else
        Vlan.create(vhash)
      end
    end
  end

  # Find FK lan_id with the given lan_name
  def find_lan_id(lan_name)
    begin  
      lan = Lan.where({lan_name: lan_name})
      return lan.id
    rescue Active::RecordNotFound
      lan = Lan.create(lan_number: Lan.count + 1, lan_name: lan_name,
        lan_description: "Automatically created by IPAMS. Please edit!")
      return lan.id
    end
  end
  
  # Determines if a VLAN already exists.
  def self.vlan_exists(vhash_to_import = {})
    exist = false
    vlans = Vlan.all # Array
    vlans = vlans.to_a.map(&:serializable_hash) # to Hash
    vlans.each do |vlan|
      if vlan == vhash_to_import
        exist = true
        break
      end 
    end

    return exist  
  end
end

