class HistoriesController < ApplicationController
  before_action :retrieve_address, only: :create

  def new
    @history = History.new
  end
  
  def create
    #@history = History.new(history_params)
    @history = History.new
    set_history_values()

    respond_to do |format|
      #if @history.save(history_params)
      if @history.save
        flash[:success] = "Address was successfully recycled."
        #format.html { redirect_to histories_path }
        format.html {}
        #format.json { render json: { locale: I18n.locale, address_id: @user_id } }
      else
        flash[:danger] = 'There was a problem recycling the Address.'
        format.html { head :no_content }
        #format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def history_params
    #params.require(:history).permit(
     # :address_id, :mac_address, :usage, :user_name, :dept_name, :office_phone, :cell_phone, :building, 
      #:room, :start_date, :end_date, :application_form) 
    params[:history].permit(:address_id)
  end

  # We need to have the address info to recycle it and create a historical record
  def retrieve_address
    address_id = params[:address_id] 
    @address = Address.find(address_id)
  end

  def set_history_values
    @user = User.find(@address.user_id)
    @department = Department.find(@user.department_id)

    @history.address_id = @address.id
    @history.mac_address = @address.mac_address
    @history.usage = @address.usage
    @history.user_name = @user.name
    @history.dept_name = @department.dept_name
    @history.office_phone = @user.office_phone
    @history.cell_phone = @user.cell_phone
    @history.building = @user.building
    @history.room = @user.room
    @history.start_date = @address.start_date
    @history.end_date = @address.end_date
    @history.application_form = @address.application_form
  end
end
