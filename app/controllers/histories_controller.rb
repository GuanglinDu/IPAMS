class HistoriesController < ApplicationController
  before_action :retrieve_address, only: :create
  before_action :set_history,      only: :destroy

  def index
    if params[:search].present?
      @search = History.order(created_at: :desc).search do
        fulltext params[:search]
        paginate page: params[:page] || 1, per_page: 30
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @histories = @search.results
    else
      # paginate returns object of 
      # type User::ActiveRecord_Relation < ActiveRecord::Relation
      @histories = History.order(created_at: :desc).paginate(
        page: params[:page],
        per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE
      )
    end

    authorize @histories
  end

  def new
    @history = History.new
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

  def destroy
    authorize @history

    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url }
      format.json { head :no_content }
    end
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  #def history_params
    #params[:history].permit(
      #:vlan_id,
      #:rec_ip,
      #:user_name,
      #:mac_address,
      #:usage,
      #:start_date,
      #:end_date,
      #:application_form,
      #:assigner,
      #:recyclable
    #)
  #end

  private

  # Use the address info to recycle it and create a historical record
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
    #@history.rec_ip = @address.ip
  end

  def set_history
    @history = History.find(params[:id])
  end
end
