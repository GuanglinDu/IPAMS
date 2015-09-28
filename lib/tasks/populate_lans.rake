# Populates table lans with ~300 records.
namespace :db do
  desc "Appends ~300 records to table lans(IPAMS-specific)"
  task :populate_lans => :environment do
    if (ENV["RAILS_ENV"] == "development")
      append_records_to_lans
    else
      puts "Task populate_lans can ONLY be invoked in the development environment."
      puts "The current environment is #{ENV["RAILS_ENV"]}!"
    end
  end

  desc "Appends ~250 VLANs to the first 2 LANs(IPAMS-specific)"
  task :populate_vlans => :environment do
    if (ENV["RAILS_ENV"] == "development")
      # Finds the first 2 LANs

      # Appends VLANs to them
      #append_records_to_vlans(lan1)
    else
      puts "Task populate_vlans can ONLY be invoked in the development environment."
      puts "The current environment is #{ENV["RAILS_ENV"]}!"
    end
  end

  def append_records_to_lans 
    puts "--- Populating table lans ..."
    # Determines the existing maximum lan_number
    lans = Lan.all
    max_lan_number = 0 # initial value
    lans.each do |lan|
      max_lan_number = [max_lan_number, lan.lan_number].max
    end    

    # Appends in a iteration
    count1 = 360
    1.upto(count1) do |i| 
      num1 = max_lan_number + i
      s1 = num1.to_s
      Lan.create!(:lan_number => s1, :lan_name => "LAN " + s1, :lan_description => "This LAN " + s1)
    end
    puts "--- #{count1} more LANs added"
  end
  
  # Appends lots of records in table vlans
  def append_records_to_vlans(lan) 
    puts "--- Populating table vlans ..."
    # Determines the existing maximum vlan_number
    vlans = Vlan.all
    max_vlan_number = 0 # initial value
    vlans.each do |vlan|
      max_vlan_number = [max_vlan_number, vlan.vlan_number].max
    end    

    # Appends in a iteration
    count1 = 250
    1.upto(count1) do |i| 
      num1 = max_vlan_number + i
      s1 = num1.to_s
      lan.vlans.create!(:vlan_number => s1, :vlan_name => "VLAN " + s1, :vlan_description => "This VLAN " + s1)
    end
    puts "--- #{count1} more VLANs added"
  end
end
