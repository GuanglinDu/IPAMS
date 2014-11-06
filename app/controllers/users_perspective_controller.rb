class UsersPerspectiveController < ApplicationController
  def index
    @departments = Department.all
  end
end
