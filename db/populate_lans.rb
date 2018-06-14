module PopulateLans
  LAN_COUNT  = 10
  VLAN_COUNT = 80 

  def create_lans
    puts "*** Creating LANs ..."
    1.upto(LAN_COUNT) do |i|
      Lan.create! lan_number: i,
                  lan_name: "LAN-#{i}",
                  lan_description: "This is LAN-#{i}"
    end
    puts "#{LAN_COUNT} LANs added to table lans"
  end

  def create_vlans(lan)
    puts "Populating LAN #{lan.lan_name} ..."
    0.upto(VLAN_COUNT) do |i| 
      s1 = i.to_s
      ip_start = "192.168." + s1 + ".0"
      ip_end   = "192.168." + s1 + ".255"
      gateway  = "192.168." + s1 + ".254"

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
    puts "#{VLAN_COUNT+1} VLANs added to LAN #{lan.lan_name}"
  end
end
