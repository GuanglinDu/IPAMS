class Vlan < ActiveRecord::Base
  require 'csv'

  # 1st line of the importing CSV file is the headers (attributes/fields)
  # Note: lan_name will be used to retrieve FK lan_id
  HEADERS = [
    "lan_name", "vlan_number", "vlan_name","static_ip_start",
    "static_ip_end", "subnet_mask", "gateway", "vlan_description"
  ]

  belongs_to :lan

  has_many :addresses, dependent: :destroy
  has_many :reserved_addresses, dependent: :destroy
  has_many :users, through: :addresses

  validates :vlan_number,
            :vlan_name,
            :subnet_mask,
            :vlan_description,
            presence: true
  # Valid VLAN number is only between 1..4096 (a Range object)
  validates :vlan_number,
            inclusion: {in: 1..4096}
  validates :gateway,
            :static_ip_start,
            :static_ip_end,
            presence: true, 
            uniqueness: true

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
    # A Hash object to contain the returning messages (one message for each row)
    # The values are Array objects to contain the importing results for each row
    msg = { success: [], info: [] }    

    # If file is nil or blank (nil != blank)
    if file.nil? or file == ""
      msg[:success] << false 
      msg[:info] << "File name is nil or blank!" 
      return msg
    end

    # If the file is non-existant ...
    if file.instance_of?(String) and !(File.file?(file)) 
      msg[:success] << false 
      msg[:info] << "File doesn't exist!" 
      return msg
    end

    # ??File submitted through html file doesn't exist!
    # http://guides.rubyonrails.org/form_helpers.html#uploading-files
    # 5.1 What Gets Uploaded
    # The object in the params hash is an instance of a subclass of IO. Depending on the size
    # of the uploaded file it may in fact be a StringIO or an instance of File backed by a temporary file.
    if file.instance_of?(StringIO)
      msg[:success] << true 
      msg[:info] << "File is an instance of StringIO!" 
    elsif file.instance_of?(File) 
      msg[:success] << true 
      msg[:info] << "File is an instance of File!" 
    else # ActionDispatch::Http::UploadedFile by html form 
      msg[:success] << true 
      msg[:info] << "Must be the ActionDispatch::Http::UploadedFile type? #{file.class}" 
    end

    # Gets the file path
    file_path = file
    file_path = file.path unless file.instance_of?(String)
    #puts "file_path = #{file_path}"

    # TODO: Checks to see if the headers are correct

    # Imports row after row
    CSV.foreach(file_path, headers: true) do |row| # CSV::Row is part Array & part Hash
      vhash = row.to_hash # temporary VLAN record hash

      # Find FK lan_id
      # Note: Do not use Symbol :lan_name here! Or will not be found. Very weird!
      # Hence, use String instead of Symbol as the Hash key where necessary
      lan_id = find_lan_id(vhash["lan_name"])
     
      # Go to the next row if an invalid lan_id was found 
      unless lan_id > 0
        msg[:success] << false 
        msg[:info] << "Cannot find FK lan_id" 
        next
      end

      # Remove lan_name field from the row as it's not a field of table vlans
      vhash.delete("lan_name")
      # and appends the FK lan_id
      vhash["lan_id"] = lan_id
      #puts vhash
      
      # Validation, see http://guides.rubyonrails.org/active_record_validations.html
      # vlan.first.update_attributes(vhash)
      # Vlan.create!(vhash)
      # TODO: Need to feedback the result to the user in the future release
      s1 = "lan_id: " << lan_id.to_s # a temporary string
      tv = Vlan.new(vhash) # temporary VLAN record
      if tv.invalid? # invalid? triggers the model validation
        msg[:success] << false
        s1 << ", invalid Vlan"
      else
        msg[:success] << true
        s1 << ", saved"
        tv.save
      end

      msg[:info] << s1
    end

    return msg
  end

  # Finds FK lan_id with the given lan_name
  def self.find_lan_id(lan_name = nil)
    # Demo to output to rails console or test running console
    #puts "hi, rails consoe"
   
     # An impossible PK id, meaning lan_id not found
    lan_id = -999

    # If lan_name is nil or blank (nil != blank), return -999
    return lan_id if lan_name.nil? or lan_name == ""

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

