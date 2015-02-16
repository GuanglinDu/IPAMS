class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        flash[:success] = 'Department was successfully created.'
        format.html { redirect_to @department }
        format.json { render action: 'show', status: :created, location: @department }
      else
        flash[:danger] = 'There was a problem creating the Department.'
        format.html { render action: 'new' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      unless nonexistent_dept? 
        if @department.update(department_params)
          flash[:success] = 'Department was successfully updated.'
          format.html { redirect_to @department }
          format.json { head :no_content }
        else
          flash[:danger] = 'There was a problem updating the Department.'
          format.html { render action: 'edit' }
          format.json { render json: @department.errors, status: :unprocessable_entity }
        end
      else
        flash[:danger] = 'NONEXISTENT department cannot be updated.'
        format.html { redirect_to @department }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy unless nonexistent_dept?
    respond_to do |format|
      flash[:danger] = 'NONEXISTENT department cannot be destroyed.' if nonexistent_dept?
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:dept_name, :location)
    end

    # Protect the NONEXISTENT department from being updated
    def nonexistent_dept?
      @department.dept_name == "NONEXISTENT"
    end
end

