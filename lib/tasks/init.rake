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
     
    # Creates user NOBODY who belongs to department NONEXISTENT
    # TODO: This user should be read-only once created
    user1 = User.create(department_id: dept1.id, name: "NOBODY")

    # Intializes VLAN by VLAN
    vlans = Vlan.all # ActiveRecord::Relation
    vlans.each do |vlan|
      #puts vlan.vlan_name
      # Retrieves the IP address range & converts them to integers

    end

    puts "*** Table vlans initialized. #{vlans.count} VLANs."
  end
end

