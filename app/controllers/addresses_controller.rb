class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = Address.all
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
  end
  
  # PATCH/PUT /addresss/1
  # PATCH/PUT /addresss/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        flash[:success] = 'Address was successfully updated.'
        format.html { redirect_to addresses_path }
        format.json { head :no_content }
      else
        flash[:danger] = 'There was a problem updating the Address.'
        format.html { render action: 'edit' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    # lan_id is FK.
    def address_params
      params[:address].permit(:vlan_id, :user_id, :ip, :mac_address, :usage, :start_date, :end_date,
        :application_form)
    end
end
