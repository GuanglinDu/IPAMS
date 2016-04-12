module PopulateTable
  LAN_COUNT = 250
  VLAN_COUNT = 255 # 0~255 

  def run
    #Address.delete_all
    #Vlan.delete_all
    #Lan.delete_all
    #User.delete_all
    #Department.delete_all

    create_system_uers
    #create_lans LAN_COUNT
    #create_vlans 1, VLAN_COUNT
  end

  def create_system_uers
    SystemUser.delete_all
    
    puts "Creating the root user tom.cat@example.com/password ..."
    SystemUser.create! email: "tom.cat@example.com",
                       role: 5,
                       password: "password",
                       password_confirmation: "password"

    puts "Creating the admin user jerry.mouse@example.com/password ..."
    SystemUser.create! email: "jerry.mouse@example.com",
                       role: 4,
                       password: "password",
                       password_confirmation: "password"
  end

  def create_lans(count)
    puts "--- Seeding lans ..."
    1.upto(count) do |i|
      Lan.create! lan_number: i,
                  lan_name: "LAN-#{i}",
                  lan_description: "This is LAN-#{i}"
    end
    puts "*** #{count} LANs added to table lans."
  end

  def create_vlans(lan_number, count)
    lan = Lan.find_by lan_number: lan_number
    if lan
      puts "--- Seeding VLAN #{lan.lan_name} ..."
      0.upto(count) do |i| 
        s1 = i.to_s
        ip_start = "192.168." + s1 + ".0"
        ip_end = "192.168." + s1 + ".255"
        gateway = "192.168." + s1 + ".254"

        # Already exists?
        vlan1 = Vlan.find_by static_ip_start: ip_start
        vlan2 = Vlan.find_by static_ip_end: ip_end
        vlan3 = Vlan.find_by gateway: gateway
        next if vlan1 or vlan2 or vlan3
 
        j = i + 1 # vlan no. from 1~4096
        lan.vlans.create! vlan_number: j,
                          vlan_name: "VLAN-#{j}",
                          static_ip_start: ip_start,
                          static_ip_end: ip_end,
                          subnet_mask: "255.255.255.0",
                          gateway: gateway,
                          vlan_description: "Automatically created VLAN-#{j}"
      end
      puts "*** #{count+1} VLANs added to LAN #{lan.lan_name}."
    end
  end
end
