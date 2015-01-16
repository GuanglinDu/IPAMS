class WelcomeController < ApplicationController
  after_action :verify_authorized, :except => :index

  # Gets the list of LANs 
  def index
  #  @lans = Lan.order(:lan_number)
  #  authorize @lans
    #policy_scope(Lan)
    #authorize :welcome, :index? # invalid
  end
end
