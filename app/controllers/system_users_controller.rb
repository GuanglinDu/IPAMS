class SystemUsersController < ApplicationController
  before_action :set_system_user, only: [:show, :edit, :update, :destroy]

  # GET /system_users
  # GET /system_users.json
  def index
    @system_users = SystemUser.order(:name)
  end

  # GET /system_users/1
  # GET /system_users/1.json
  def show
  end

  # GET /system_users/new
  def new
    @system_user = SystemUser.new
  end

  # GET /system_users/1/edit
  def edit
  end

  # POST /system_users
  # POST /system_users.json
  def create
    @system_user = SystemUser.new(system_user_params)

    respond_to do |format|
      if @system_user.save
        flash[:success] = "System user #{@system_user.name} was successfully created."
        #format.html { redirect_to @system_user, notice: 'System user was successfully created.' }
        format.html { redirect_to system_users_url, notice: "User #{@system_user.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @system_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @system_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_users/1
  # PATCH/PUT /system_users/1.json
  def update
    respond_to do |format|
      if @system_user.update(system_user_params)
        flash[:success] = "System user #{@system_user.name} was successfully updated."
        format.html { redirect_to system_user_url, notice: "System user #{@system_user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @system_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_users/1
  # DELETE /system_users/1.json
  def destroy
    @system_user.destroy
    respond_to do |format|
      format.html { redirect_to system_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_user
      @system_user = SystemUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_user_params
      params.require(:system_user).permit(:name, :password, :password_confirmation)
    end
end
