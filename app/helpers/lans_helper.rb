# All models are accessible to both helpers & views
module LansHelper
  # Eric Torrey - Disambiguate Rails helpers:
  # https://thoughtbot.com/blog/disambiguate-rails-helpers
  def self.find_lan_name(id)
    name = "unnamed"
    begin
      name  = Lan.find(id).lan_name
    rescue ActiveRecord::RecordNotFound
      name = "RecordNotFound"
    end
    name
  end

  # Creates a cache key for the Lan#index view with pagination.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +offset+:: the offset of the pagination 
  def cache_key_for_lans(caller_name, offset)
    max_updated_at = Lan.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "lans/#{caller_name}-#{offset}-#{max_updated_at}"
  end

  # Creates a cache key for a single LAN.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +lan+:: the LAN object, a record 
  def cache_key_for_lan(caller_name, lan)
    updated_at = lan.updated_at.try(:utc).try(:to_s, :number)
    "lans/#{caller_name}-#{lan.id}-#{updated_at}"
  end

  #var data = [
  #  {vlan_name: "VLAN1", used: 472, free: 552},
  #  {vlan_name: "VLAN2", used: 769, free: 255},
  #  {vlan_name: "VLAN3", used: 156, free: 100},
  #  {vlan_name: "VLAN4", used: 972, free: 52},
  #  {vlan_name: "VLAN5", used: 28, free: 100},
  #  {vlan_name: "VLAN6", used: 56, free: 200},
  #  {vlan_name: "VLAN7", used: 96, free: 32},
  #  {vlan_name: "VLAN8", used: 322, free: 702}
  #];
  def self.do_lan_stats(lan)
    data = []
    lan.vlans.each do |vlan|
      info = WelcomeHelper.calc_vlan_usage(vlan)
      data.push({vlan_name: vlan.vlan_name, used: info[1] - info[2],
                 free: info[2]})
    end

    # Sorts the array of hashes according to vlan_names
    data = data.sort_by { |h| h[:name] }
  end
end
