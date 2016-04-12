require 'csv'

namespace :export do
  desc "exports IPs to a CSV file"
  task ips: :environment do
    vlans = Vlan.all

    filename = "#{Rails.root}/tmp/ips.xlsx" 
    p = Axlsx::Package.new
    wb = p.workbook
    vlans.each do |vlan|
      #export_addresses(vlan.id, vlan.vlan_name) 
      export_to_excel(vlan.id, vlan.vlan_name, wb) 
    end
    p.serialize filename
  end
  
  private

  # export addresses to csv
  def export_addresses(vlan_id, vlan_name)
    column_headers = ["IP",
                      "User Name",
                      "Dept Name",
                      "Office Phone",
                      "Building",
                      "Room"]
    nobody = User.find_by(name: 'NOBODY')
    addresses = Address.where(
      ['vlan_id = ? AND user_id <> ?',vlan_id, nobody.id])

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

  def export_to_excel(vlan_id, vlan_name, wb)
    wb.add_worksheet(name: vlan_name) do |sheet|
      sheet.add_row ["IP",
                     "User Name",
                     "Dept Name",
                     "Office Phone",
                     "Building",
                     "Room"]
      write2sheet(vlan_id, sheet)
    end
  end

  def write2sheet(vlan_id, sheet) 
    nobody = User.find_by(name: 'NOBODY')
    addresses = Address.where(
      ['vlan_id = ? AND user_id <> ?',vlan_id, nobody.id]
    )
    
    user_ip_count = how_many_ips_user_has(addresses)

    addresses.each do |addr|
      user = User.find_by(id: addr.user_id)
      department = Department.find_by(id: user.department_id)

      user_name = user.name.to_sym
   
      if user_ip_count[user_name][:output_count] == nil
        user_ip_count[user_name][:output_count] = 0
      end

      if user_ip_count[user_name][:ip_count] >= 10
        if user_ip_count[user_name][:output_count] < 2
          add_row(sheet, addr, user, department)
          user_ip_count[user_name][:output_count] += 1
        end
      else 
        add_row(sheet, addr, user, department)
      end
    end
  end

  def add_row(sheet, addr, user, department)
    sheet.add_row [addr.ip,
                   user.name,
                   department.dept_name,
                   user.office_phone,
                   user.building,
                   user.room]
  end

  def how_many_ips_user_has(addresses)
    user_ip_count = {}
    addresses.each do |addr|
      user = User.find_by(id: addr.user_id)
      user_name = user.name.to_sym

      if user_ip_count[user_name] == nil
        user_ip_count[user_name] = {}
      end
      if user_ip_count[user_name][:ip_count]
        user_ip_count[user_name][:ip_count] += 1
      else
        user_ip_count[user_name][:ip_count] = 1
      end
    end
    return user_ip_count
  end
end
