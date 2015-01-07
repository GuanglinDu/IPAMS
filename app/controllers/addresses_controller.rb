class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  # Updates FK user_id
  #before_update


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
      # Updates the FK user_id here
      pars = address_params
      pars[:user_id] = find_user_id(pars[:user_id])
      if @address.update(pars)
        flash[:success] = "Address was successfully updated. #{address_params.inspect}"
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

   # Resolves FK user_id before saving the modified @address
   def find_user_id(name)
     user = User.find_by(name: name)
     unless user
       u1 = Department.find_by(dept_name: 'NONEXISTENT').users.create(name: name)
       user = u1 if u1.valid?
       user ||= User.find_by(name: 'NOBODY')
     end
     user.id
   end
end
