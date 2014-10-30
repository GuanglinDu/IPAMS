class VlansController < ApplicationController

  # Create a VLAN record
  def create
    @lan = Lan.find(params[:lan_id])
    @vlan = @lan.vlans.create(params[:vlan].permit(:vlan_number, :vlan_name,
       :static_ip_start, :static_ip_end, :subnet_mask, :gateway, :vlan_description))
    redirect_to lan_path(@lan)
  end

end
