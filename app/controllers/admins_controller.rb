class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.order(:email)
    authorize @admins
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # GET /admins/new
  def new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins
  # POST /admins.json
  def create
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        flash[:success] = "Admin #{@admin.email} was successfully updated."
        format.html {
          redirect_to admin_url,
                      notice: "Admin #{@admin.email} was successfully updated."
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json {
          render json: @admin.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def admin_params
    params.require(:admin).permit(:email)
  end
end
