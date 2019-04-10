class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy, :recycle]

  # Resolves the FK user_id before updating a record
  before_action :convert_user_name_to_user_id, only: :update
  before_action :set_recycled_address_values,  only: :recycle

  # No keywords, no search. Goes to the paginated views, instead.
  # See https://github.com/sunspot/sunspot
  # See also http://www.whatibroke.com/?p=235
  def index
    if params[:keywords].present?
      search = Address.search do
        fulltext params[:keywords]

        nobody_id = User.find_by(name: "NOBODY").id
        if params[:option] == "Assigned"
          without(:user_id, nobody_id)
        elsif params[:option] == "Free"
          with(:user_id, nobody_id)
        end

        paginate page:     params[:page] || 1,
                 per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @addresses = search.results
    elsif params[:option].present? && (params[:option] != "All")
      nobody_id = User.find_by(name: "NOBODY").id
      if params[:option] == "Assigned"
        @addresses = Address.where.not(user_id: nobody_id).paginate(
          page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
      elsif params[:option] == "Free"
        @addresses = Address.where(user_id: nobody_id).paginate(
          page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
      end
    else
      # paginate returns object of 
      # type User::ActiveRecord_Relation < ActiveRecord::Relation
      @addresses = Address.paginate(page: params[:page],
        per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
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

    @histories = History.where(
      address_id: @address.id).paginate(page: params[:page],
      per_page:   IPAMSConstants::RECORD_COUNT_PER_PAGE
    )
    authorize @histories

    respond_to do |format|
      format.html
      format.json { render json: {pk: @address.id,
                                  ip: @address.ip,
                                  locale: I18n.locale} }
    end
  end

  def edit
    authorize @address
  end

  # An IP address can not be destroyed but should be recycled, instead.
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
        format.json { render json: {locale: I18n.locale,
                                    user_id: @user_id,
                                    recyclable: @address.recyclable} }
      else
        flash[:danger] = "There was a problem updating the address."
        format.html { render action: 'edit' }
        format.json { render json: @address.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1/recycle
  # PUT /addresses/1/recycle.json
  def recycle
    authorize @address

    respond_to do |format|
      if @address.save
        flash[:success] = "Address was successfully recycled."
        format.html { head :no_content }
        format.json { render json: {locale: I18n.locale,
                                    user_id: @user.id} }
      else
        flash[:danger] = "There was a problem recycling the address."
        format.html { head :no_content }
        format.json { render json: @address.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions
  def set_address
    @address = Address.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def address_params
    params[:address].permit(:vlan_id,
                            :user_id,
                            :ip,
                            :mac_address,
                            :usage,
                            :start_date,
                            :end_date,
                            :application_form,
                            :assigner,
                            :recyclable)
  end

  # Changes a user.name to its user.id (FK user_id) as only the FK is going to
  # be stored in the Address object (record). Here's the trick to save an id
  # while showing its name.
  def convert_user_name_to_user_id
    @pars = address_params
    if @pars.has_key?("user_id")
      name = @pars[:user_id]
      if name
        @pars[:user_id] = find_user_id(name) unless integer?(name)
      end
    end
  end

  # Resolves FK user_id before saving the modified @address. If the user
  # doesn't exist, create a new one belonging to the NONEXISTENT department.
  def find_user_id(name)
    user = User.find_by(name: name.strip) # Removes whitespaces
    unless user
      u1 = Department.find_by(dept_name: 'NONEXISTENT').users.create(name: name)
      user = u1 if u1.valid?
      user ||= User.find_by(name: 'NOBODY')
    end
    @user_id = user.id
  end
  
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
