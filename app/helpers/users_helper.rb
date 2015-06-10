module UsersHelper
  # Tables relationship: departments -> users -> addresses
  def find_user(id)
    @user = User.find(id)
    find_department(@user.department_id)
  end
end
