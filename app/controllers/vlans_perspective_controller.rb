# This perspective is used to show the VLANs info directly
# without starting from the LANs which parent VLANs. 
class VlansPerspectiveController < ApplicationController
  def index
    @lans = Lan.order(:lan_number)
  end
end
