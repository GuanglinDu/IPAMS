module PopulateAdmins
  def create_admins
    Admin.delete_all
    
    puts "Creating the root user tom.cat@example.com/password ..."
    Admin.create! email: "tom.cat@example.com",
                  role: 5,
                  password: "password",
                  password_confirmation: "password"

    puts "Creating the admin user jerry.mouse@example.com/password ..."
    Admin.create! email: "jerry.mouse@example.com",
                  role: 4,
                  password: "password",
                  password_confirmation: "password"
  end
end
