class ReservedAddressesController < ApplicationController
  def index
  end
    before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /reservedAddresses
  # GET /reservedAddresses.json
  def index
    @reservedAddresses = ReservedAddresses.all
  end

  # GET /reservedAddresses/1
  # GET /reservedAddresses/1.json
  def show
  end

  # GET /reservedAddresses/new
  def new
    @department = ReservedAddresses.new
  end

  # GET /reservedAddresses/1/edit
  def edit
  end

  # POST /reservedAddresses
  # POST /reservedAddresses.json
  def create
    @department = ReservedAddresses.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
        format.json { render action: 'show', status: :created, location: @department }
      else
        format.html { render action: 'new' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservedAddresses/1
  # PATCH/PUT /reservedAddresses/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservedAddresses/1
  # DELETE /reservedAddresses/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to reservedAddresses_url }
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
end
