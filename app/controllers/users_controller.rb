class UsersController < ApplicationController
  include IPAMSConstants

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    #@users = User.all # mem killer!
    keywords = params[:search]
    keywords = keywords.strip if keywords

    # No keywords, no search; paginate all, instead.
    @users = nil
    if keywords && keywords != "" 
      #search = Sunspot.search(Address)
      search = User.search do
        fulltext keywords
        # See http://www.whatibroke.com/?p=235
        paginate :page => params[:page] || 1, :per_page => 30
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @users = search.results
    else
      @users = User.paginate(page: params[:page], per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    end

    authorize @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.'
        format.html { redirect_to @user }
        format.json { render action: 'show', status: :created, location: @user }
      else
        flash[:error] = 'User was NOT successfully created.'
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      # Updates the FK department_id here as only department name is manipulated
      pars = user_params
      name = pars[:department_id]
      if name
        pars[:department_id] = find_department_id(name) unless integer?(name)
      end

      # Prevents user NOBODY from being modified
      unless nobody? 
       if @user.update(pars)
          flash[:success] = 'User was successfully updated.'
          format.html { redirect_to @user }
          format.json { head :no_content }
        else
          flash[:error] = 'User was NOT successfully updated.'
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
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
    @user.destroy unless nobody?
    respond_to do |format|
      flash[:alert] = 'User NOBODY CANNOT be destroyed.' if nobody?
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :office_phone, :cell_phone, :email, :building, :storey, :room, :department_id)
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

   def integer?(str)
     /\A[+-]?d+\z/ === str
   end
end
