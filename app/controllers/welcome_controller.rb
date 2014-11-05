# The data for VLANs perspective can be retrieved here. 
class WelcomeController < ApplicationController
  
  # Gets the list of lans and vlans 
  def index
    @lans = Lan.order(:lan_number)
  end
end
