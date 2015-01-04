# See Intro to Rake by Shneems: https://www.youtube.com/watch?v=gR0YfJrg9pg
# Dependency task :environment which is a Rails rake task loading models, etc.

# Initializes table vlans (IPAMS-specific)
# TODO: Seems this should be enabled on the web UI.
namespace :init do
  # Assigns the initial IP Addresses to NOBODY who belongs to department NONEXISTENT
  desc "Initializes table vlans (IPAMS-specific)"
  task vlans: :environment do
    # Creates department named NONEXISTENT
    # TODO: This department should be read-only once created
    dept1 = Department.create(dept_name: "NONEXISTENT", location: "NOWHRER")
    dept1 = Department.find_by(dept_name: "NONEXISTENT") unless dept1.valid?
     
    # Creates user NOBODY who belongs to department NONEXISTENT
    # TODO: This user should be read-only once created
    user1 = User.create(department_id: dept1.id, name: "NOBODY")
    # Or create this way
    #user1 = dept1.users.create(department_id: dept1.id, name: "NOBODY")
    user1 = User.find_by(name: "NOBODY") unless user1.valid?

    # Intializes VLAN by VLAN by populating with the IP addresses
    vlans = Vlan.all # ActiveRecord::Relation
    #vlans = Vlan.find_by(vlan_name: 'home-test')
    #[vlans].each do |vlan|
    vlans.each do |vlan|
      #puts vlan.vlan_name
      # Retrieves the IP address range & converts them to integers
      # Note: validates the addresses in the model
      ip1 = vlan.static_ip_start.split('.') # string split to string arrays
      ip2 = vlan.static_ip_end.split('.')
      (ip1[0].to_i..ip2[0].to_i).each do |i0|
        s0 = i0.to_s + '.'
        (ip1 [1].to_i..ip2[1].to_i).each do |i1|
          s1 = s0 + i1.to_s + '.'
          (ip1 [2].to_i..ip2[2].to_i).each do |i2|
            s2 = s1 + i2.to_s + '.'
            (ip1 [3].to_i..ip2[3].to_i).each do |i3|
              #addr = i0.to_s << '.' << i1.to_s << '.' << i2.to_s << '.' <<i3.to_s 
              addr = s2 + i3.to_s 
              vlan.addresses.create(user_id: user1.id, ip: addr)
            end
          end
        end
      end
    end

    puts "*** Table vlans initialized. #{vlans.count} VLANs."
  end
end

