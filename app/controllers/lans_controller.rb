class LansController < ApplicationController
  before_action :set_lan, only: [:show, :edit, :update, :destroy]
  #after_action :verify_authorized, except: :index
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: :index

  # GET /lans
  # GET /lans.json
  def index
    @lans = Lan.order(:lan_number).paginate(page: params[:page],
      per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @lans
    #policy_scope(@lans)
  end

  # GET /lans/1
  # GET /lans/1.json
  def show
    @vlans = @lan.vlans.order(:vlan_number).paginate(page: params[:page],
      per_page: IPAMSConstants::RECORD_COUNT_PER_PAGE)
    authorize @vlans
  end

  # GET /lans/new
  def new
    @lan = Lan.new
    authorize @lan
  end

  # GET /lans/1/edit
  def edit
    authorize @lan
  end

  # POST /lans
  # POST /lans.json
  def create
    @lan = Lan.new(lan_params)
    authorize @lan

    respond_to do |format|
      if @lan.save
        flash[:success] = "Lan was successfully created."
        format.html { redirect_to @lan,
                                  notice: "LAN was successfully created." }
        format.json { render action: "show", status: :created, location: @lan }
      else
        flash[:danger] = "There was a problem creating the LAN."
        format.html { render action: "new" }
        format.json { render json: @lan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lans/1
  # PATCH/PUT /lans/1.json
  def update
    authorize @lan

    respond_to do |format|
      if @lan.update(lan_params)
        flash[:success] = 'Lan was successfully updated.'
        format.html { redirect_to @lan,
                                  notice: 'Lan was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:danger] = 'There was a problem updating the Lan.'
        format.html { render action: 'edit' }
        format.json { render json: @lan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lans/1
  # DELETE /lans/1.json
  def destroy
    authorize @lan

    @lan.destroy
    respond_to do |format|
      format.html { redirect_to lans_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lan
    @lan = Lan.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def lan_params
    params.require(:lan).permit(:lan_number, :lan_name, :lan_description)
  end
end
