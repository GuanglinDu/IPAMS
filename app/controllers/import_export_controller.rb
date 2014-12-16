class ImportExportController < ApplicationController
  def index
  end

  def import
    flash[:success] = 'VLANs was successfully imported.'
    #Vlan.import(params[:file])
    #redirect_to vlans_url, notice: "VLANs imported."
  end

  def export
    flash[:success] = 'VLANs was successfully exported.'
  end
end
