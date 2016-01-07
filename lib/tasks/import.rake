# See Intro to Rake by Shneems: https://www.youtube.com/watch?v=gR0YfJrg9pg
# Dependency task :environment which is a Rails rake task loading models, etc.
require 'active_support/core_ext'
require 'csv'
require_relative 'import_helper'
require_relative 'file_helper'

include ImportHelper

# Imports data to table lans, vlans, departments (IPAMS-specific)
# TODO: Importing should be availabe through the web UI.
namespace :import do
  log_file = File.open(FileHelper::IMPORT_LOG, "w")
  diff_file = File.open(FileHelper::IMPORT_DIFF, "w")

  desc "imports LANs from a CVS file (IPAMS-specific)"
  task lans: :environment do
    file_path = FileHelper::LAN_IMPORT_SOURCE_FILE
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      h1 = ImportHelper::strip_whitespace(raw_row) # temporary hash

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
    #require 'csv' 
    # Opens the FileHelper::IMPORT_LOG.txt file
    #log_file = File.open(FileHelper::IMPORT_LOG, "w")
    #file_path = "#{Rails.root}/tmp/vlan_importing_template.csv" 
    file_path = FileHelper::VLAN_IMPORT_SOURCE_FILE
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      vh1 = ImportHelper::strip_whitespace(raw_row)
      puts vh1

      # Resolves lan_id by replacing the lan_name key-value pair with lan_id pair
      ln = vh1["lan_name"]
      ln = vh1[:lan_name] unless ln
      ln = ln.strip if ln
      puts "ln = #{ln}"

      lan1 = Lan.find_by(:lan_name => ln)
      unless lan1
        log_file.puts "lan_name: #{ln} not found!"
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
    #require 'csv'
    # Opens the FileHelper::IMPORT_LOG.txt file
    #log_file = File.open(FileHelper::IMPORT_LOG, "w")
    #file_path = "#{Rails.root}/tmp/departments_importing_template.csv" 
    file_path = FileHelper::DEPARTMENT_IMPORT_SOURCE_FILE
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      h1 = ImportHelper::strip_whitespace(raw_row) # temporary hash

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
    #require 'csv'
    # Opens the FileHelper::IMPORT_LOG.txt file
    #log_file = File.open(FileHelper::IMPORT_LOG, "w")
    #diff_file = File.open(FileHelper::IMPORT_DIFF, "w")
    #file_path = "#{Rails.root}/tmp/ip_address_importing_template.csv" 
    file_path = FileHelper::IP_IMPORT_SOURCE_FILE

    ImportHelper::create_html_header(diff_file)
 
    CSV.foreach(file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      iph = ImportHelper::strip_whitespace(raw_row) # temporary IP hash

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
        user1 = User.new(ImportHelper::user_to_h(department_id, iph))

        if user1.valid?
          log_file.puts "New user #{iph["name"]} created!"
          user1.save
        else
          log_file.puts "ERROR: Cannot create User: #{iph["name"]}"
          next
        end
      else # update user
        User.update user1.id, ImportHelper::user_to_h(department_id, iph)
      end
      user_id = user1.id

      note = "??? Ooops, nothing done!" # importing result
      # IP addresses need updating only. Do not create new IP addresses.
      # Determines whether the IP address exists. If yes, updates it;
      # Note: Using iph[:ip] leads to failing finding the lan_name from Hash h1!!!
      ip1 = Address.find_by(ip: iph["ip"])
      #puts iph.to_s

      unless ip1
        note = "ERROR: IP address NOT found!"
        display_n_log "#{iph["ip"]}: #{note}", log_file

        next
      else # updates
        # Let's resolve FK vlan_id with the IP address
        vlan_id = ip1.vlan_id
        # Extracts the IP address hash from iph, appending the 2 FKs
        ip_hash = create_ip_hash(vlan_id, user_id, iph)

        # Resolves user name from User.find_by(id: ip1.user_id)
        user2 = User.find_by(id: ip1.user_id)
        # Only imports nonexistent, flaged as yes or new records
        if user2.name == 'NOBODY' || update?(iph["update"]) || new_record?(ip1, iph) 
          update_address(ip1, ip_hash)
          note = "Imported/Updated successfully!"
        else # Outputs duplicate records
          old_attr = ImportHelper::address_to_a(ip1, user2.name)
          new_attr = ImportHelper::address_hash_to_a(iph, user1.name)

          note = "The existing is identical with the one to be imported. Ignored!"
          if old_attr != new_attr
            log_file.puts "--- Warnning: duplicate records:"
            diff_file.puts "<br />*** Existing ***<br />"
            diff_file.puts ImportHelper::address_to_s(ip1, user2.name)
            new_attr = ImportHelper::address_hash_to_a(iph, user1.name)         
            ImportHelper::output_comparision_result(old_attr, new_attr, diff_file)
            note = "Conflict with the existing, not imported, diff output!"
          end
        end
      end
      display_n_log "#{ip1.ip}: #{note}", log_file
    end
    
    ImportHelper::append_html_tail(diff_file)
    puts "*** IP addresses importing done!"
  end

  private

    # Outputs a prompt & logs the result for each row (IP address)
    def display_n_log(msg, log_file)
      puts msg
      log_file.puts msg
    end

    # See the implementation of task ips above
    # addr, an Address object; addr_hash, the IP address hash to be imported 
    def update_address(addr, addr_hash)
      Address.update addr.id, addr_hash
    end
    
    def create_ip_hash(vlan_id, user_id, iph)
      {vlan_id: vlan_id,
      user_id: user_id,
      ip: iph["ip"],
      mac_address: iph["mac_address"],
      usage: iph["usage"],
      application_form: iph["application_form"],
      start_date: iph["start_date"],
      end_date: iph["end_date"]}
    end

    # Attention: In Ruby, nil is false, while 0 is true (Non-nil is true).
    def update?(str)
      r = nil
      if str && str.instance_of?(String)
        str.strip!
        str.downcase!
        r = 1 if str == 'y' || str == 'yes'
      end
      return r
    end

    # Determines whether the record to be imported is new according to the datetime
    # ip, the existing Address record; iph, the Hash to be imported as a new Address record
    def new_record?(ip, iph)
      r = nil
      # Creates a TimeWithZone instance from the String object
      new_start_date = Time.zone.parse(iph["start_date"]) if iph["start_date"] 
      if ip.start_date && new_start_date  
        r = new_start_date > ip.start_date
      # The existing record has no start_date
      elsif new_start_date && !(ip.start_date)  
        r = 1
      end
      return r
    end
 end
