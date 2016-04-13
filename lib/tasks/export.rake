require 'csv'

namespace :export do
  desc "exports IPs to a CSV file"
  task ips: :environment do
    #vlans = Vlan.all.map { |v| v.id }
    vlans = Vlan.all

    vlans.each do |vlan|
      export_addresses(vlan.id, vlan.vlan_name) 
    end
  end
  
  private

  def export_addresses(vlan_id, vlan_name)
    column_headers = ["IP",
                    "User Name",
                    "Dept Name",
                    "Office Phone",
                    "Building",
                    "Room"]
    nobody = User.find_by(name: 'NOBODY')
    addresses = Address.where(['vlan_id = ? AND user_id <> ?',vlan_id, nobody.id])

    file_path = "#{Rails.root}/tmp/#{vlan_name}.csv" 
    CSV.open(file_path, 'w', headers: column_headers) do |writer|
      addresses.each do |addr|
        users = User.find_by(id: addr.user_id)
        departments = Department.find_by(id: users.department_id)
        writer << [addr.ip,
                   users.name,
                   departments.dept_name,
                   users.office_phone,
                   users.building,
                   users.room]
      end 
    end
  end
end
