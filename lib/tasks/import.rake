# See Intro to Rake by Shneems: https://www.youtube.com/watch?v=gR0YfJrg9pg
# Dependency task :environment which is a Rails rake task loading models, etc.

# Imports data to table lans, vlans, departments (IPAMS-specific)
# TODO: Importing should be availabe through the web UI.
namespace :import do
  # To contain the import result 
  IMPORT_LOG = "#{Rails.root}/tmp/IMPORT_LOG.txt" 
  IMPORT_DIFF = "#{Rails.root}/tmp/IMPORT_DIFF.html" 

  desc "imports LANs from a CVS file (IPAMS-specific)"
  task lans: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
    diff_file = File.open(IMPORT_DIFF, "w")
   
    file_path = "#{Rails.root}/tmp/lans_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      h1 = strip_whitespace(raw_row) # temporary hash

      note = "OK" # importing result
      # Determines whether the Lan exists. If yes, updates it;
      # Note: Using h1[:lan_name] leads to failing finding the lan_name from Hash h1!!!
      if Lan.exists? lan_name: h1["lan_name"]
        note = "OK. Updated!"
        l1 = Lan.find_by lan_name: h1["lan_name"]
        Lan.update l1.id, h1
      else # or, creates a new Lan
        new_lan = Lan.new(h1)
        if new_lan.valid?
          note = "OK. Newly created!"
          new_lan.save
        else
          note = new_lan.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      #h1[:note] = note
      log_file.puts note
    end
    
    puts "*** LANs imported!"
  end

  # Imports VLAN info
  # A VLAN has 1 FK lan_id to resolve
  desc "imports VLANs from a CVS file (IPAMS-specific)"
  task vlans: :environment do
    require 'csv' 
 
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")

    file_path = "#{Rails.root}/tmp/vlan_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      vh1 = strip_whitespace(raw_row)
      
      # Resolves lan_id by replacing the lan_name key-value pair with lan_id pair
      lan1 = Lan.find_by(lan_name: vh1['lan_name'])
      unless lan1
        log_file.puts "lan_name: #{vh1['lan_name']} not found!"
        next
      end
      vh1.delete('lan_name')
      vh1[:lan_id] = lan1.id

      note = "OK" # importing result
      # Determines whether the Vlan exists. If yes, updates it;
      # Note: Using vh1[:vlan_name] leads to failing finding the lan_name from Hash h1!!!
      if Vlan.exists?(vlan_name: vh1["vlan_name"])
        note = "OK. Updated!"
        vl1 = Vlan.find_by(vlan_name: vh1["vlan_name"])
        Vlan.update vl1.id, vh1
      else # or, creates a new Lan
        new_vlan = Vlan.new(vh1)
        if new_vlan.valid?
          note = "OK. Newly created!"
          new_vlan.save
        else
          note = new_vlan.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      log_file.puts note
    end
    
    puts "*** VLANs imported!"
  end

  desc "imports Departments from a CVS file (IPAMS-specific)"
  task departments: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
   
    file_path = "#{Rails.root}/tmp/departments_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      h1 = strip_whitespace(raw_row) # temporary hash

      note = "OK" # importing result
      # Determines whether the Department exists. If yes, updates it;
      # Note: Using h1[:dept_name] leads to failing finding the dept_name from Hash h1!!!
      if Department.exists? dept_name: h1["dept_name"]
        note = "OK. Updated!"
        d1 = Department.find_by dept_name: h1["dept_name"]
        Department.update d1.id, h1
      else # or, creates a new Department
        new_dept = Department.new(h1)
        if new_dept.valid?
          note = "OK. Newly created!"
          new_dept.save
        else
          note = new_dept.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      log_file.puts note
    end
    
    puts "*** Departments imported!"
  end

  # Imports IPs with VLAN info
  # An IP has 2 FKs vlan_id & user_id to resolve
  desc "imports IPs from a CVS file (IPAMS-specific)"
  task ips: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
    diff_file = File.open(IMPORT_DIFF, "w")
   
    file_path = "#{Rails.root}/tmp/ip_address_importing_template.csv" 
    create_html_header(diff_file)
 
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      iph = strip_whitespace(raw_row) # temporary IP hash

      # Resolves talbe users' FK department_id
      department1 = Department.find_by(dept_name: iph["dept_name"])
      unless department1
        log_file.puts "ERROR: Cannot find FK of dept_name: #{iph["dept_name"]}"
        next
      end
      department_id = department1.id

      # Resolves table addresses' FKs user_id & creates a new User if not found
      user1 = User.find_by(name: iph["name"])
      unless user1
        user1 = User.new(
          department_id: department_id,
          name: iph["name"],
          office_phone: iph["office_phone"].to_i,
          cell_phone: iph["cell_phone"].to_i,
          email: iph["email"],
          building: iph["building"],
          storey: iph["storey"].to_i,
          room: iph["room"].to_i)

        if user1.valid?
          log_file.puts "New user #{iph["name"]} created!"
          user1.save
        else
          log_file.puts "ERROR: Cannot create User: #{iph["name"]}"
          next
        end
      else # update user
        user_hash = { department_id: department_id,
          name: iph["name"],
          office_phone: iph["office_phone"].to_i,
          cell_phone: iph["cell_phone"].to_i,
          email: iph["email"],
          building: iph["building"],
          storey: iph["storey"].to_i,
          room: iph["room"].to_i }

        User.update user1.id, user_hash
      end
      user_id = user1.id

      note = "OK" # importing result
      # IP addresses need updating only. Do not create new IP addresses.
      # Determines whether the IP address exists. If yes, updates it;
      # Note: Using iph[:ip] leads to failing finding the lan_name from Hash h1!!!
      ip1 = Address.find_by(ip: iph["ip"])
      unless ip1
        log_file.puts "ERROR: Cannot find IP address: #{iph["ip"]}"
        next
      else # updates
        # Let's resolve FK vlan_id with the IP address
        vlan_id = ip1.vlan_id

        note = "OK. Updated!"
        # Extracts the IP address hash from iph, appending the 2 FKs
        ip_hash = { vlan_id: vlan_id,
          user_id: user_id,
          ip: iph["ip"],
          mac_address: iph["mac_address"],
          usage: iph["usage"],
          application_form: iph["application_form"],
          start_date: iph["start_date"],
          end_date: iph["end_date"] }

        if user1.name == 'NOBODY' # updates non-existing records
          address_update(ip1, ip_hash)
        else # Outputs duplicate records
          log_file.puts "--- Warnning: duplicate records:"
          diff_file.puts "<br />**** Existing *******************<br />"

          old_attr = ["ip: " + iph["ip"],
            "MAC: " + atrribute_to_s(iph["mac_address"]),
            "Usage: " + atrribute_to_s(iph["usage"]),
            "User: " + atrribute_to_s(user1.name),
            "start_date: " + atrribute_to_s(iph["start_date"]),
            "Assigner: " + atrribute_to_s(iph["assigner"])]
          diff_file.puts old_attr

          new_attr = ["ip: " + ip1.ip,
            "MAC: " + atrribute_to_s(ip1.mac_address),
            "Usage: " + atrribute_to_s(ip1.usage),
            "User: " + atrribute_to_s(user1.name),
            "start_date: " + atrribute_to_s(ip1.start_date),
            "Assigner: " + atrribute_to_s(ip1.assigner)]

          #diff_file.puts new_attr

          diff_file.puts "<br />*** To import ***********<br />"

          diff_file.puts compare_value(old_attr[0], new_attr[0])[1]
          diff_file.puts compare_value(old_attr[1], new_attr[1])[1]
          diff_file.puts compare_value(old_attr[2], new_attr[2])[1]
          diff_file.puts compare_value(old_attr[3], new_attr[3])[1]
          diff_file.puts compare_value(old_attr[4], new_attr[4])[1]
          diff_file.puts compare_value(old_attr[5], new_attr[5])[1]

          diff_file.puts "<br />~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br />"
          #diff_file.puts new_attr
          #diff_file.puts old_attr
        end
      end

      # Logs the result for each row
      #h1[:note] = note
      log_file.puts note
    end
    
    append_html_tail(diff_file)
    puts "*** IP addresses imported!"
  end

  private
    
    # Strips the whitespaces from both the key and the value
    def strip_whitespace(raw_row = {})
      row = {}
      raw_row.each do |k, v|
        vt = nil
        vt = v.strip if v
        row[k] = vt
      end
      row.to_hash.with_indifferent_access
    end

    # See the implementation of taks ips above
    # addr: an Address object
    # addr_hash: the IP address hash to be imported 
    def address_update(addr, addr_hash)
      Address.update addr.id, addr_hash
    end

    # addr: an Address object
    def address_to_s(addr, user)
      "ip: " + addr.ip + ", " + 
      "MAC :" + atrribute_to_s(addr.mac_address) + ", " + 
      "Usage: " + atrribute_to_s(addr.usage) + ", " +
      "User: " + atrribute_to_s(user.name) + ", " +
      "start_date: " + atrribute_to_s(addr.start_date) + ", " +
      "Assigner: " + atrribute_to_s(addr.assigner) 
    end

    def atrribute_to_s(field)
      s1 = ""
      s1 = field.to_s if field
      s1.strip
    end

    def compare_value(v1, v2)
      result = ["", ""]
      v1 = atrribute_to_s(v1)
      v2 = atrribute_to_s(v2)
 
      if v1 == v2
        result[0] = result[1] = v1
      else
        result[0] = v1
        result[1] = %{<b>#{v2}</b>}
      end

      result
    end

    def create_old_attr_array(attr)
    end

    def create_new_attr_array(attr)
    end

    def create_html_header(diff_file)
      diff_file.puts %{<!DOCTYPE html>}
      diff_file.puts %{<html>}
      diff_file.puts %{<head>}
      diff_file.puts %{<meta charset="utf-8" />}
      diff_file.puts %{<title></title>}
      diff_file.puts %{</head>}
      diff_file.puts %{<body>}
    end

    def append_html_tail(diff_file)
      diff_file.puts %{\n</body>}
      diff_file.puts %{</html>}
    end
end
