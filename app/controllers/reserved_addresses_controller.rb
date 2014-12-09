class ReservedAddressesController < ApplicationController
  def index
  end
    before_action :set_reserved_address, only: [:show, :edit, :update, :destroy]

  # GET /reserved_addresses
  # GET /reserved_addresses.json
  def index
    @reserved_addresses = ReservedAddress.all
  end

  # GET /reserved_addresses/1
  # GET /reserved_addresses/1.json
  def show
  end

  # GET /reserved_addresses/new
  def new
    @reserved_address = ReservedAddress.new
  end

  # GET /reserved_addresses/1/edit
  def edit
  end

  # POST /reserved_addresses
  # POST /reserved_addresses.json
  def create
    @reserved_address = ReservedAddress.new(reserved_address_params)

    respond_to do |format|
      if @reserved_address.save
        format.html { redirect_to vlan_path(Vlan.find(@reserved_address.vlan_id)), notice: 'Reserved address was successfully created.' }
        #format.html { redirect_to @reserved_address, notice: 'Reserved address was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reserved_address }
      else
        format.html { render action: 'new' }
        format.json { render json: @reserved_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reserved_addresses/1
  # PATCH/PUT /reserved_addresses/1.json
  def update
    respond_to do |format|
      if @reserved_address.update(reserved_address_params)
        format.html { redirect_to vlan_path(find_vlan(@reserved_address)), notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reserved_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reserved_addresses/1
  # DELETE /reserved_addresses/1.json
  def destroy
    @reserved_address.destroy
    respond_to do |format|
      format.html { redirect_to reserved_addresses_url }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_reserved_address
      @reserved_address = ReservedAddress.find(params[:id])
    end

    def find_vlan(reserved_address)
      Vlan.find(reserved_address.vlan_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reserved_address_params
      params[:reserved_address].permit(:vlan_id, :ip, :description)
    end
end
