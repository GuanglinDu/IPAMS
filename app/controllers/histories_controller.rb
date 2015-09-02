class HistoriesController < ApplicationController
  before_action :retrieve_address, only: :create

  def new
    @history = History.new
  end
  
  def show
    authorize @history
    respond_to do |format|
      format.html
      format.json { render json: { locale: I18n.locale} }
    end
  end

  def create
    @history = History.new
    set_history_values()

    respond_to do |format|
      if @history.save
        flash[:success] = "Address was successfully recycled."
        format.html { head :no_content }
        format.js
        format.json { render json: { locale: I18n.locale} }
      else
        flash[:danger] = 'There was a problem recycling the Address.'
        format.html { head :no_content }
      end
    end
  end

private

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
