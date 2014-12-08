class VlansController < ApplicationController
#  include CurrentLan

  before_action :set_vlan, :only => [:show, :edit, :update, :destroy]

  def index
    @vlans = Vlan.order(:vlan_number)
  end

  # Create a VLAN record
  def create
    @vlan = @vlans.create(vlan_params)
    redirect_to vlans_path
  end

  # Updates are implemented by methods edit and update
  def edit
  end 
 
  # PUT /vlans/:id
  # PUT /vlans/:id.xml
  def update
    respond_to do |format|
      if @vlan.update(vlan_params)
        #1st argument of redirect_to is an array, in order to build the correct route to the nested resource vlan
        #format.html { redirect_to [@vlan.lan, @vlan], notice: 'Comment was successfully updated.' }
        format.html { redirect_to @vlan.lan, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vlan.errors, status: :unprocessable_entity }
      end
    end
  end

  # Import a CSV file into table vlans
  def import
    Vlan.import(params[:file])
    redirect_to vlans_url, notice: "VLANs imported."
  end

  # Destroy a VLAN record
  def destroy
    @vlan.destroy
    redirect_to vlans_path
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_vlan
      @vlan = Vlan.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def vlan_params
      params[:vlan].permit(:vlan_number, :vlan_name, :static_ip_start, :static_ip_end,
        :subnet_mask, :gateway, :vlan_description)
    end
end
