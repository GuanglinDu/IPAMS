class HistoriesController < ApplicationController
  def new
    @history = History.new
  end
  
  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @distory.save(history_params)
        flash[:success] = "Address was successfully updated. #{address_params.inspect}"
        format.html { redirect_to addresses_path }
        format.json { render json: { locale: I18n.locale, user_id: @user_id } }
      else
        flash[:danger] = 'There was a problem updating the Address.'
        format.html { render action: 'edit' }
        format.json { render json: @distory.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def history_params
    params[:history].permit(:address_id, :mac_address, :usage, :user_name, :dept_name, :office_phone, :cell_phone, :building, 
      :room, :start_date, :end_date, :application_form) 
  end
end
