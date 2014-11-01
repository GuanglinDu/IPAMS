class VlansController < ApplicationController
  before_action :set_lan, only: [:create, :show, :edit, :update, :destroy]
  before_action :set_vlan, :only => [:show, :edit, :update, :destroy]

  # Create a VLAN record
  def create
    #@lan = Lan.find(params[:lan_id])
    @vlan = @lan.vlans.create(vlan_params)
    redirect_to lan_path(@lan)
  end

  def show
    #@lan = Lan.find(params[:lan_id])
    #@vlan = @lan.vlans.find(params[:id])
  end

  # Destroy a VLAN record
  def destroy
    #@lan = Lan.find(params[:lan_id])
    #@vlan = @lan.vlans.find(params[:id])
    @vlan.destroy
    redirect_to lan_path(@lan)
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_lan
      @lan = Lan.find(params[:lan_id])
    end

    def set_vlan
      @vlan = Vlan.find(params[:id])
      #@vlan = @lan.vlans.find(params[:id]) # also do
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def vlan_params
      params[:vlan].permit(:vlan_number, :vlan_name, :static_ip_start, :static_ip_end,
        :subnet_mask, :gateway, :vlan_description)
    end
end
