# Populates table departments with ~300 records.
module PopulateDepartments
  DEPARTMENT_COUNT = 50
  USER_COUNT = 200

  def create_departments 
    puts "*** Creating departments ..."
    1.upto(DEPARTMENT_COUNT) do |i|
      name =  Faker::Commerce.department
      dept = Department.find_by(dept_name: name)
      Department.create!(dept_name: name,
                         location: Faker::Address.street_address) unless dept
    end
    puts "~#{DEPARTMENT_COUNT} departments added"
  end

  def populate_department_with_users(department_name) 
    department = Department.find_by(dept_name: department_name)
    if department
      create_users(department)
    else
      puts "ERROR: Department #{department_name} not found!"
    end
  end
  
  # A user belongs to department 
  def create_users(department) 
    puts "--- Populating users to department #{department.dept_name} ..."
    1.upto(USER_COUNT) do |i| 
      name = Faker::Name.name
      name2 = User.find_by(name: name)
      unless name2
        department.users.create!(
          name: name,
          title: Faker::Name.title,
          office_phone: Faker::PhoneNumber.phone_number,
          cell_phone: Faker::PhoneNumber.cell_phone,
          email: Faker::Internet.email(name),
          building: "Building " + Faker::Address.building_number,
          room: Faker::Number.number(3)
        )
      end
    end

    puts "~#{USER_COUNT} more users appended to department " \
         "#{department.dept_name}"
  end
end
