class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.order(:dept_name).paginate(page: params[:page],
      per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @departments

    gon.locale = I18n.locale
  
    respond_to do |format|
      format.html
      format.json { render json: DepartmentsHelper.do_department_stats }
    end        
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @users = @department.users.paginate(page: params[:page],
      per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @department
  end

  # GET /departments/new
  def new
    @department = Department.new
    authorize @department
  end

  # GET /departments/1/edit
  def edit
    authorize @department
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)
    authorize @department

    respond_to do |format|
      if @department.save
        flash[:success] = 'Department was successfully created.'
        format.html { redirect_to @department }
        format.json { render action: 'show', status: :created,
                             location: @department }
      else
        flash[:error] = 'There was a problem creating the Department.'
        format.html { render action: 'new' }
        format.json { render json: @department.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    authorize @department

    respond_to do |format|
      unless nonexistent_dept? 
        if @department.update(department_params)
          flash[:success] = 'Department was successfully updated.'
          format.html { redirect_to @department }
          format.json { head :no_content }
        else
          flash[:error] = 'There was a problem updating the Department.'
          format.html { render action: 'edit' }
          format.json { render json: @department.errors,
                               status: :unprocessable_entity }
        end
      else
        flash[:alert] = 'NONEXISTENT department CANNOT be updated.'
        format.html { redirect_to @department }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    authorize @department

    @department.destroy unless nonexistent_dept?
    respond_to do |format|
      if nonexistent_dept?
        flash[:alert] = 'NONEXISTENT department CANNOT be destroyed.'
      end
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_department
    @department = Department.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def department_params
    params.require(:department).permit(:dept_name, :location)
  end

  # Protects the NONEXISTENT department from being updated
  def nonexistent_dept?
    @department.dept_name == "NONEXISTENT"
  end
end  
