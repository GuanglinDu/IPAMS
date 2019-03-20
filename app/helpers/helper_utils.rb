module HelperUtils
  # Finds the latest update datetime in Address, User & Department
  def max_department_user_address_updated_at
    max = Address.maximum(:updated_at)
    t1 = Department.maximum(:updated_at)
    max = t1 if t1 > max
    t1 = User.maximum(:updated_at)
    max = t1 if t1 > max
    max
  end
end
