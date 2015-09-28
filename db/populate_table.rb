module PopulateTable
  def run
    # Test data for table lans
    ReservedAddress.delete_all
    Vlan.delete_all
    Lan.delete_all

    lan1 = Lan.create!(:lan_number => 1, :lan_name => "Legacy LAN",
      :lan_description => %{The traditional LAN with 4-C LANs each.})
    lan2 = Lan.create!(:lan_number => 2, :lan_name => "Datacenter LAN",
      :lan_description => %{The new LAN with 1-C LAN each inside the DC building.})

    # Test data for table vlans
    vlan11_of_lan1 = Vlan.create!(lan_id: lan1.id, vlan_number: 11, vlan_name: "VLAN_11", subnet_mask: "255.255.255.0",
      gateway: "192.168.0.254", static_ip_start: "192.168.0.0", static_ip_end: "192.168.0.255", 
      vlan_description: "Storey 1 of the Main Building")
    vlan12_of_lan1 = Vlan.create!(lan_id: lan1.id, vlan_number: 12, vlan_name: "VLAN_12", subnet_mask: "255.255.255.0",
      gateway: "192.168.1.254", static_ip_start: "192.168.1.0", static_ip_end: "192.168.1.255", 
      vlan_description: "Storey 2 of the Main Building")

    vlan21_of_lan2 = Vlan.create!(lan_id: lan2.id, vlan_number: 21, vlan_name: "VLAN_21", subnet_mask: "255.255.255.0",
      gateway: "192.168.2.254", static_ip_start: "192.168.2.0", static_ip_end: "192.168.2.255", 
      vlan_description: "Storey 1 of Building DC")
    vlan22_of_lan2 = Vlan.create!(lan_id: lan2.id, vlan_number: 22, vlan_name: "VLAN_22", subnet_mask: "255.255.255.0",
      gateway: "192.168.3.254", static_ip_start: "192.168.3.0", static_ip_end: "192.168.3.255", 
      vlan_description: "Storey 2 of Building DC")

    # Test data for table reserved_addresses
    ReservedAddress.create!(vlan_id: vlan11_of_lan1.id, ip: "192.168.0.0", description: "subnet number")
    ReservedAddress.create!(vlan_id: vlan11_of_lan1.id, ip: "192.168.0.255", description: "broadcast address")
    ReservedAddress.create!(vlan_id: vlan11_of_lan1.id, ip: "192.168.0.254", description: "subnet mask")
    ReservedAddress.create!(vlan_id: vlan12_of_lan1.id, ip: "192.168.1.0", description: "subnet number")
    ReservedAddress.create!(vlan_id: vlan12_of_lan1.id, ip: "192.168.1.255", description: "broadcast address")
    # Or creates this way
    vlan12_of_lan1.reserved_addresses.create(ip: "192.168.1.254", description: "subnet mask")

    # Test data for table departments
    Address.delete_all
    User.delete_all
    Department.delete_all
    dept_geophysics = Department.create!(dept_name: "Geophysics", location: "Building Geophysics")
    dept_geology = Department.create!(dept_name: "Geology", location: "Storey 1-2, Building Main")
    dept_computer = Department.create!(dept_name: "Computer", location: "Storey 4, 8 and 9, Building DC")

    # Test data for table users
    user1_of_dept_geophysics = User.create!(department_id: dept_geophysics.id, name: "Tom", office_phone: 2727,
      cell_phone: 13912345678, email: "nobody@example.com", building: "DC", storey: 9, room: 901) 
    user2_of_dept_geophysics = User.create!(department_id: dept_geophysics.id, name: "Jerry", office_phone: 2728,
      cell_phone: 13922345678, email: "nobody2@example.com", building: "Main", storey: 4, room: 402) 
    user1_of_dept_geology = User.create!(department_id: dept_geology.id, name: "Cathy", office_phone: 2727,
      cell_phone: 13932345678, email: "nobody3@example.com", building: "DC", storey: 19, room: 1901) 
    user2_of_dept_geology = User.create!(department_id: dept_geology.id, name: "Jack", office_phone: 2728,
      cell_phone: 13942345678, email: "nobody4@example.com", building: "Main", storey: 24, room: 2402) 
    user1_of_dept_computer = User.create!(department_id: dept_computer.id, name: "Brown", office_phone: 2727,
      cell_phone: 13952345678, email: "nobody5@example.com", building: "DC", storey: 1, room: 102) 
    user2_of_dept_computer = User.create!(department_id: dept_computer.id, name: "Obama", office_phone: 2728,
      cell_phone: 13962345678, email: "nobody6@example.com", building: "Main", storey: 2, room: 202) 

    # Test data for table addresses
    dt1 = DateTime.now
    dt2 = dt1 + 365*5 # 5 years later
    ip1 = Address.create!(vlan_id: vlan11_of_lan1.id, user_id: user1_of_dept_geophysics.id,
      ip: "192.168.0.0", usage: "Office PC", start_date: dt1, end_date: dt2, application_form: "none")
    ip2 = Address.create!(vlan_id: vlan11_of_lan1.id, user_id: user2_of_dept_geophysics.id,
      ip: "192.168.0.1", usage: "Office PC", start_date: dt1, end_date: dt2, application_form: "none")

    # Test data for table histories
  end
end
