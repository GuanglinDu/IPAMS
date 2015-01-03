# See Intro to Rake by Shneems: https://www.youtube.com/watch?v=gR0YfJrg9pg
# Dependency task :environment which is a Rails rake task loading models, etc.

# Imports data to table lans, vlans, departments (IPAMS-specific)
# TODO: Importing should be availabe through the web UI.
namespace :import do
  # To contain the import result 
  IMPORT_LOG = "#{Rails.root}/tmp/IMPORT_LOG.txt" 

  desc "imports LANs from a CVS file (IPAMS-specific)"
  task lans: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
   
    file_path = "#{Rails.root}/public/download/lans_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |row| # CSV::Row is part Array & part Hash
      h1 = row.to_hash # temporary hash
      
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
          #new_lan.errors[:lan_number].any?, "lan_number must not be blank"
          #new_lan.errors[:lan_name].any?, "lan_name must not be blank"
          #new_lan.errors[:lan_description].any?, "lan_description must not be blank"
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
  # A VLAN has 1 FK lan_id to be resolved
  desc "imports VLANs from a CVS file (IPAMS-specific)"
  task vlans: :environment do
    require 'csv' 
 
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
  end

  # Imports IPs with VLAN info
  # An IP has 2 FKs vlan_id & user_id to resolve
  desc "imports IPs from a CVS file (IPAMS-specific)"
  task ips: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
   
    file_path = "#{Rails.root}/public/download/ips_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |row| # CSV::Row is part Array & part Hash
      iph = row.to_hash # temporary IP hash
      
      note = "OK" # importing result
      # Determines whether the Vlan exists. If yes, updates it;
      # Note: Using iph[:vlan_name] leads to failing finding the lan_name from Hash h1!!!
      if Vlan.exists? vlan_name: iph["vlan_name"]
        note = "OK. Updated!"
        vl1 = Vlan.find_by vlan_name: iph["vlan_name"]
        Vlan.update vl1.id, h1
      else # or, creates a new Lan
        new_vlan = Vlan.new(h1)
        if new_vlan.valid?
          note = "OK. Newly created VLAN!"
          new_vlan.save
        else
          note = new_vlan.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      #h1[:note] = note
      log_file.puts note
    end
    
    puts "*** IP address data imported!"
  end
end

