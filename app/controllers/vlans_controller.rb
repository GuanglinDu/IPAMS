class VlansController < ApplicationController

  # Create a VLAN record
  def create
    @lan = Lan.find(params[:lan_id])
    @vlan = @lan.vlans.create(params[:vlan].permit(:vlan_number, :vlan_name,
       :vlan_description, :subnet_mask, :static_ip_start, :static_ip_end))
    redirect_to lan_path(@lan)
  end

end
