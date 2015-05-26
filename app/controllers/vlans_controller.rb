class VlansController < ApplicationController
  include IPAMSConstants

  before_action :set_vlan, :only => [:show, :edit, :update, :destroy]
  #after_action :verify_authorized, except: :index
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: :index

  def index
    #@vlans = Vlan.order(:vlan_number)
    @vlans = Vlan.paginate(page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE).order(:vlan_number)
    authorize @vlans
    #policy_scope(@vlans)
  end

  # GET /vlans/new
  def new
    @vlan = Vlan.new
    authorize @vlan
  end

  # Create a new VLAN
  def create
    @vlan = Vlan.new(vlan_params)
    authorize @vlan

    respond_to do |format|
      if @vlan.save
        flash[:success] = 'VLAN was successfully created.'
        format.html { redirect_to vlans_path, notice: 'VLAN was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vlan }
      else
        flash[:danger] = 'There was a problem creating the VLAN.'
        format.html { render action: 'new' }
        format.json { render json: @vlan.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @addresses = Address.where(vlan_id: @vlan.id).paginate(page: params[:page],
      per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @vlan
    authorize @addresses
  end 

  # Updates are implemented by methods edit and update
  def edit
    authorize @vlan
  end 

  # PUT /vlans/:id
  # PUT /vlans/:id.xml
  def update
    authorize @vlan

    respond_to do |format|
      if @vlan.update(vlan_params)
        flash[:success] = 'Vlan was successfully updated.'
        #1st argument of redirect_to is an array, in order to build the correct route to the nested resource vlan
        #format.html { redirect_to [@vlan.lan, @vlan], notice: 'VLAN was successfully updated.' }
        format.html { redirect_to @vlan, notice: 'Vlan was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:danger] = 'There was a problem updating the VLAN.'
        format.html { render action: 'edit' }
        format.json { render json: @vlan.errors, status: :unprocessable_entity }
      end
    end
  end

  # Import a CSV file into table vlans
  # 1. Importing from CSV in Rails: http://kyle.conarro.com/importing-from-csv-in-rails
  # 2. Rails: Use controller for import: https://github.com/rest-client/rest-client
  def import
    flash[:success] = 'VLANs were successfully imported.'
    Vlan.import(params[:file])
    redirect_to vlans_url
  end

  # Destroy a VLAN record
  def destroy
    authorize @vlan

    @vlan.destroy
    redirect_to vlans_path
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_vlan
      @vlan = Vlan.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    # lan_id is FK.
    def vlan_params
      params[:vlan].permit(:lan_id, :vlan_number, :vlan_name, :static_ip_start, :static_ip_end,
        :subnet_mask, :gateway, :vlan_description)
    end
end

