# This perspective is used to show all the users' info directly
# without starting from the departments which parent users. 
class UsersPerspectiveController < ApplicationController
  def index
    @departments = Department.all
  end
end
