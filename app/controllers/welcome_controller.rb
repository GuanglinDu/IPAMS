class WelcomeController < ApplicationController
  # Gets the list of LANs 
  def index
    @lans = Lan.order(:lan_number)
  end
end
