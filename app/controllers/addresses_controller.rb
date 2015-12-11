class AddressesController < ApplicationController

 before_action :set_address, only: [:show, :edit, :update, :destroy, :recycle]
  after_action :verify_authorized
  #after_action :verify_authorized, except: :index
  #after_action :verify_policy_scoped, only: :index

  # Resolves the FK user_id before updating a record
  before_action :convert_user_name_to_user_id, only: :update

  # No keywords, no search. Goes to the paginated views, instead.
  def index
    @addresses = nil
    if params[:search].present?
      search = Address.search do
        fulltext params[:search]
        # See http://www.whatibroke.com/?p=235
        paginate :page => params[:page] || 1, :per_page => 30
      end 
      
      # Type Sunspot::Search::PaginatedCollection < Array
      @addresses = search.results
    else
      # paginate returns object of type User::ActiveRecord_Relation < ActiveRecord::Relation
      @addresses = Address.paginate(page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    end

    authorize @addresses
    #policy_scope(@addresses)
  end

  def new
    @address = Address.new
    authorize @address
  end

  # Locale used in hitories/create.js.erb to recycle the address
  def show
    authorize @address
    @histories = History.where(address_id: @address.id).paginate(page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @histories

    respond_to do |format|
      format.html
      format.json { render json: { pk: @address.id, ip: @address.ip, locale: I18n.locale } }
    end
  end

  def edit
    authorize @address
  end

  def destroy
    authorize @address
  end
  
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    authorize @address

    respond_to do |format|
      if @address.update(@pars)
        flash[:success] = "Address was successfully updated. #{@pars.inspect}"
        format.html { redirect_to addresses_path }
        format.json { render json: { locale: I18n.locale, user_id: @user_id, recyclable: @address.recyclable }}
      else
        flash[:danger] = "There was a problem updating the address."
        format.html { render action: 'edit' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1/recycle
  # PUT /addresses/1/recycle.json
  def recycle
    authorize @address
    set_recycled_address_values()

    respond_to do |format|
      if @address.save
        flash[:success] = "Address was successfully recycled."
        format.json { render json: { locale: I18n.locale, user_id: @user.id }}
      else
        flash[:danger] = "There was a problem recycling the address."
        format.html { head :no_content }
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
      #params[:address].permit(:vlan_id, :user_id, :room, :ip, :mac_address, :usage, :start_date, :end_date,
        #:application_form, :assigner, :recyclable)
      params[:address].permit(:vlan_id, :user_id, :ip, :mac_address, :usage, :start_date, :end_date,
        :application_form, :assigner, :recyclable)
    end

    # Changes a user.name to its user.id (FK user_id) as only the FK is going to be stored
    # in the Address object (record). Here's the trick to save an id while showing its name
    def convert_user_name_to_user_id
      @pars = address_params # access by reference
      if @pars.has_key?("user_id")
        name = @pars[:user_id]
        if name
          @pars[:user_id] = find_user_id(name) unless integer?(name)
        end
      end
    end

    # Resolves FK user_id before saving the modified @address
    # If the user doesn't exist, create a new one belonging to the NONEXISTENT department
    def find_user_id(name)
      user = User.find_by(name: name)
      unless user
        u1 = Department.find_by(dept_name: 'NONEXISTENT').users.create(name: name)
        user = u1 if u1.valid?
        user ||= User.find_by(name: 'NOBODY')
      end
      @user_id = user.id # accessable in the class scope
    end
    
    # Empties recycled address values 
    def set_recycled_address_values
      @user = User.find_by(name: 'NOBODY')
      @department = Department.find(@user.department_id)

      @address.user_id = @user.id
      @address.mac_address = nil
      @address.usage = nil
      @address.start_date = nil
      @address.end_date = nil
      @address.application_form = nil
      @address.assigner = nil
      @address.recyclable = false
    end   
end
