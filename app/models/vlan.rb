class Vlan < ActiveRecord::Base
  require 'csv'

  # 1st line of the importing CSV file is the headers (attributes, fields)
  # Note: lan_name will be used to retrieve FK lan_id
  HEADERS = ["lan_name", "vlan_number", "vlan_name","static_ip_start",
    "static_ip_end", "subnet_mask", "gateway", "vlan_description"]

  validates :vlan_number, :vlan_name, :subnet_mask, :vlan_description, presence: true
  # Valid VLAN number is only between 1..4096 (an Range object)
  validates :vlan_number, inclusion: { in: 1..4096 }
  validates :gateway, :static_ip_start, :static_ip_end, presence: true, uniqueness: true

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
  # Creates a class method as does Vlan.import
  def self.import(file = nil)
    # A Hash object to contain the returning messages
    msg = { success: false, error: ""  }    

    # If the file is non-existant ...
    unless File.exists?(file)
      msg[:error] = "Invalid file name" 
      return msg
    end

    # TODO: Checks to see if the headers are correct

    row_count = 0
    msg[:error] = "errors"
    CSV.foreach(file.path, headers: true) do |row| # CSV::Row is part Array & part Hash
      vhash = row.to_hash # temporary VLAN record hash

      # Find FK lan_id
      lan_id = self.find_lan_id(vhash[:lan_name])
     
      # Go to the next row if invalid lan_id was found 
      next unless lan_id > 0

      msg[:error] << "," << lan_id.to_s
      msg[:success] = true

      vhash[:lan_id] = lan_id # appends the lan_id FK
      
      # Remove lan_name field from the row as it's not a field of table vlans
      #vhash.delete(:lan_name)
      
      # Validation, see http://guides.rubyonrails.org/active_record_validations.html
      # vlan.first.update_attributes(vhash)
      # Vlan.create!(vhash)
      # Need to feedback the result to the user in the future release
     # tv = Vlan.new(vhash) # temporary VLAN record
     # if tv.invalid? # invalid? triggers the validation
     #   next # no continue in Ruby!
     # else
     #   tv.save
     # end
    end

    return msg
  end

  # Finds FK lan_id with the given lan_name
  def self.find_lan_id(lan_name = nil)
    lan_id = -999 # An impossible PK, meaning lan_id not found

    # If lan_name is nil or blank (nil != blank), return -999
    return lan_id unless lan_name
    return lan_id if lan_name == ""

    #lan = Lan.where({lan_name: lan_name}) # Note: returns an ActiveRecord::Relation object
    lan1 = Lan.find_by lan_name: lan_name # returns an Lan object
    if lan1
      lan_id = lan1.id
    else # Try creating a new Lan
      new_lan = Lan.create(lan_number: Lan.count + 1, lan_name: lan_name,
        lan_description: "Automatically created by IPAMS. Please edit!")
      lan_id = new_lan.id if new_lan.valid?      
    end

    return lan_id
  end
  
  # Deprecated on Dec. 19, 2014 as it's clumsy. Use rails validation instead.
  # Determine if a VLAN already exists.
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

