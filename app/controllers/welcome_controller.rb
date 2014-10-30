class WelcomeController < ApplicationController
  
  # Gets the list of lans, vlans
  def index
    @lans = Lan.order(:lan_number)
  end
end
