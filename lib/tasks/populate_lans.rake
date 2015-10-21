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

  # Usage rake db:populate_lan["my_lan_name"]
  desc "Appends ~200 VLANs to the specified LAN(IPAMS-specific)"
  task :populate_lan, [:lan_name] => :environment do |t, args|
    if (ENV["RAILS_ENV"] == "development")
      lan = Lan.find_by(lan_name: args.lan_name)
      if lan
        append_records_to_lan(lan)
      else
        puts "ERROR: LAN #{args.lan_name} not found!"
      end
    else
      puts "Task populate_lan can ONLY be invoked in the development environment."
      puts "The current environment is #{ENV["RAILS_ENV"]}!"
    end
  end

  # Appends ~360 records to table lans
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
      Lan.create!(:lan_number => s1, :lan_name => "LAN " + s1, :lan_description => "This is LAN " + s1)
    end
    puts "--- #{count1} more LANs added"
  end
  
  # Appends ~200 records to a specified lan
  def append_records_to_lan(lan) 
    puts "--- Populating vlans to LAN #{lan.lan_name} ..."
    # Determines the existing maximum vlan_number
    vlans = Vlan.all
    max_vlan_number = 0 # initial value
    vlans.each do |vlan|
      max_vlan_number = [max_vlan_number, vlan.vlan_number].max
    end    

    # Appends the VLANs in a iteration
    count1 = 200
    1.upto(count1) do |i| 
      num1 = max_vlan_number + i
      s1 = num1.to_s

      # Already exists?      
      ip_start = "192.168." + i.to_s + ".0"
      ip_end = "192.168." + i.to_s + ".255"
      gateway = "192.168." + i.to_s + ".254"
      vlan1 = Vlan.find_by(static_ip_start: ip_start)
      vlan2 = Vlan.find_by(static_ip_end: ip_end)
      vlan3 = Vlan.find_by(gateway: gateway)
      next if vlan1 or vlan2 or vlan3

      puts "Appending VLAN #{s1} ..."
      lan.vlans.create!(
        :vlan_number => s1,
        :vlan_name => "VLAN " + s1,
        :static_ip_start => ip_start,
        :static_ip_end => ip_end,
        :subnet_mask => "255.255.255.0",
        :gateway => gateway,
        :vlan_description => "Automatically created VLAN " + s1)
    end

    puts "--- #{count1} more VLANs added to LAN #{lan.lan_name}."
  end
end
