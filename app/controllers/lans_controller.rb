class LansController < ApplicationController
  before_action :set_lan, only: [:show, :edit, :update, :destroy]

  # GET /lans
  # GET /lans.json
  def index
    @lans = Lan.all
  end

  # GET /lans/1
  # GET /lans/1.json
  def show
    #@lan = Lan.find(params[:id])
  end

  # GET /lans/new
  def new
    @lan = Lan.new
  end

  # GET /lans/1/edit
  def edit
  end

  # POST /lans
  # POST /lans.json
  def create
    @lan = Lan.new(lan_params)

    respond_to do |format|
      if @lan.save
        format.html { redirect_to @lan, notice: 'Lan was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lan }
      else
        format.html { render action: 'new' }
        format.json { render json: @lan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lans/1
  # PATCH/PUT /lans/1.json
  def update
    respond_to do |format|
      if @lan.update(lan_params)
        format.html { redirect_to @lan, notice: 'Lan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lans/1
  # DELETE /lans/1.json
  def destroy
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def lan_params
      params.require(:lan).permit(:lan_number, :lan_name, :lan_description)
    end
end
