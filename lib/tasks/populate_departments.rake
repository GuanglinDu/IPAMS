# Populates table departments with ~300 records.
namespace :db do
  desc "Appends ~300 records to table departments(IPAMS-specific)"
  task :populate_departments => :environment do
    if (ENV["RAILS_ENV"] == "development")
      append_records_to_departments
    else
      hint "bundle exec rake db:populate_departments RAILS_ENV=development"
    end
  end

  # Usage rake db:populate_department["my_department_name"]
  desc "Appends ~200 users to the specified Department(IPAMS-specific)"
  task :populate_department, [:department_name] => :environment do |t, args| 
    if (ENV["RAILS_ENV"] == "development")
      department = Department.find_by(dept_name: args.department_name)
      if department
        append_records_to_department(department)
      else
        puts "ERROR: Department  #{args.department_name} not found!"
      end
    else
      hint "bundle exec rake db:populate_department['DEPARTMENT_NAME']" \
           " RAILS_ENV=development"
    end
  end

  # Appends 360 records to table departments with gem faker
  # https://github.com/stympy/faker
  def append_records_to_departments 
    puts "--- Populating table departments ..."
    # Appends in a iteration
    count1 = 360
    1.upto(count1) do |i|
      name =  Faker::Commerce.department
      dept = Department.find_by(dept_name: name)
      Department.create!(dept_name: name,
        location: Faker::Address.street_address) unless dept
    end
    puts "--- ~#{count1} more departments added"
  end
  
  # Appends ~250 users to a specified department with gem faker
  def append_records_to_department(department) 
    puts "--- Populating users to department #{department.dept_name} ..."

    # Appends the VLANs in a iteration
    count1 = 250
    1.upto(count1) do |i| 
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

    puts "--- ~#{count1} more users appended to department " \
      "#{department.dept_name}."
  end

  def hint(usage)
    puts "Task populate_department ONLY runs in the devel environment.\n" \
         "The current environment is #{ENV["RAILS_ENV"]}!\n" \
         "Usage:\n\t#{usage}"
  end
end
