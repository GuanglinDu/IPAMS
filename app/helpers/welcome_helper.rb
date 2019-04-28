module WelcomeHelper
  #root = {name: "Network", children: [{
  #    name:     "Legacy LAN",
  #    children: [{name: "VLAN 1", children: [{name: "Address", size: 1024}]},
  #               {name: "VLAN 2", children: [{name: "Address", size: 1024}]}]
  #  }]
  #}
  def self.do_statistics
    root = {name: "RIPED Network", children: []}
    Lan.all.each do |lan|
      lanNode = {name: "#{lan.lan_name}", children: []}
      root[:children].push(lanNode)

      lan.vlans.each do |vlan|
        vlanNode = {name: "#{vlan.vlan_name}", children: []}
        lanNode[:children].push(self.calc_vlan_usage(vlan, vlanNode))
      end
    end
   root
  end

  def self.calc_vlan_usage(vlan, node)
     total_ip_count    = vlan.addresses.count
     nobody_id = AddressesHelper.find_nobody_id
     free_ip_count = Address.where(["user_id = ? and vlan_id = ?",
				    "#{nobody_id}", "#{vlan.id}"]).count
     ratio = "#{free_ip_count}" + "/" + "#{total_ip_count}"
     node[:children].push({name: "#{ratio}", size: total_ip_count})
     node
  end
end
