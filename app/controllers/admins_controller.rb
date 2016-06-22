class AdminsController < ApplicationController
  before_action :set_admin, only: [:update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.order(:email)
    authorize @admins
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    authorize @admin

    respond_to do |format|
      if @admin.update(admin_params)
        flash[:success] = "Admin #{@admin.email} was successfully updated."
        format.html { redirect_to admins_url,
          notice: "Admin #{@admin.email} was successfully updated." }
        format.json { render json: {role: admin_params[:role]} }
      else
        format.html { render action: 'index' }
        format.json { render json: @admin.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    authorize @admin

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
    params.require(:admin).permit(:email, :role, :name)
  end
end
