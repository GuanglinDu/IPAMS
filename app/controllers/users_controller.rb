class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # Resolves the FK department_id before updating a record
  before_action :convert_dept_name_to_dept_id, only: :update

  # GET /users
  # GET /users.json
  def index
    # No keywords, no search; paginate all, instead
    if params[:search].present?
      search = User.search do
        fulltext params[:search]
        # See http://www.whatibroke.com/?p=235
        paginate :page => params[:page] || 1, :per_page => 30
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @users = search.results
    else
      @users = User.paginate(page: params[:page],
                             per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    end

    authorize @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user
    respond_to do |format|
      format.html
      format.json { render json: user_info_in_json }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    authorize @user
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        flash[:success] = "User #{@user.name} was successfully created."
        format.html { redirect_to @user }
        format.json { render action: 'show', status: :created, location: @user }
      else
        flash[:error] = "User was NOT successfully created."
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user

    respond_to do |format|
      # Prevents user NOBODY from being modified
      unless nobody? 
       if @user.update(@pars)
          flash[:success] = "User #{@user.name} was successfully updated."
          format.html { redirect_to @user }
          #format.json { head :no_content }
          format.json { render json: user_info_in_json }
        else
          flash[:error] = 'User was NOT successfully updated.'
          format.html { render action: 'edit' }
          format.json { render json: @user.errors,
                               status: :unprocessable_entity }
        end
      else
        flash[:alert] = 'User NOBODY CANNOT be updated.'
        format.html { redirect_to @user }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user

    # Recycle the associated IP addresses before deleting the user.
    count = @user.addresses.count 
    if  count > 0
      info = "User #{@user.name} has #{count} address(es) assigned." \
             " Recycle first!"
    else
      @user.destroy unless nobody?
      info1 = "User NOBODY CANNOT be destroyed."
      info2 = "User #{@user.name} destroyed."
      nobody? ? info=info1 : info=info2
    end

    respond_to do |format|
      flash[:alert] = info
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :title, :office_phone, :cell_phone,
      :email, :building, :storey, :room, :department_id)
  end

  # Protect user NOBODY from being updated
  def nobody?
    @user.name == "NOBODY"
  end

  # dept_name must exist, or department NONEXISTENT will be assigned.
  # No new department to be created.
  def find_department_id(name)
    dept = Department.find_by(dept_name: name)
    dept ||= Department.find_by(dept_name: 'NONEXISTENT')
    dept.id
  end

  # Maps the department name to its PK as is the FK of a user because
  # the department name is displayed on the views. This applied to both
  # the addresses view and the users view. The FK department_id is going to be
  # saved instead of the department name in the User table.
  def convert_dept_name_to_dept_id
    @pars = user_params
    name = @pars[:department_id]
    if name
      @pars[:department_id] = find_department_id(name) unless integer?(name)
    end
  end

  # Responds in the json format to the ajax request
  def user_info_in_json
    {
      pk: @user.id,
      room: @user.room,
      locale: I18n.locale,
      storey: @user.storey,
      user_name: @user.name,
      user_title: @user.title,
      building: @user.building,
      cell_phone: @user.cell_phone,
      office_phone: @user.office_phone,
      department: find_department_name(@user.department_id)
    }
  end
end
