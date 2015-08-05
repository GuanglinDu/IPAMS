class AddressesController < ApplicationController
  include IPAMSConstants
  include ApplicationHelper 

  before_action :set_address, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  #after_action :verify_authorized, except: :index
  #after_action :verify_policy_scoped, only: :index

  # Resolves the FK user_id before updating a record
  before_action :change_user_name_to_user_id, only: :update

  def index
    keywords = params[:search]
    keywords = keywords.strip if keywords

    # No keywords, no search
    @addresses = nil
    if keywords && keywords != "" 
      #search = Sunspot.search(Address)
      search = Address.search do
       fulltext keywords
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

  def show
    authorize @address
    respond_to do |format|
      format.html
      format.json { render json: {pk: @address.id, ip: @address.ip} }
    end
  end

  def edit
    authorize @address
  end

  def destroy
    authorize @address
  end
  
  # PATCH/PUT /addresss/1
  # PATCH/PUT /addresss/1.json
  def update
    authorize @address

    respond_to do |format|
      # Updates the FK user_id, converting a user name to a user_id
      if @address.update(@pars)
        flash[:success] = "Address was successfully updated. #{@pars.inspect}"
        format.html { redirect_to addresses_path }
        #format.json { head :no_content }
        format.json { render json: { locale: I18n.locale, user_id: @user_id, recyclable: @address.recyclable }}
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
      params[:address].permit(:vlan_id, :user_id, :room, :ip, :mac_address, :usage, :start_date, :end_date,
        :application_form, :assigner, :recyclable)
    end

   # FindChanges user.name to user.id (FK user_id) as  
   def change_user_name_to_user_id
     # Updates the FK user_id here, converting a user name to a user_id
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
end
