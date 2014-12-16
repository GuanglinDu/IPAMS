class ImportExportController < ApplicationController

  # Entry to importing/exporting
  def index
  end

  def import
    #flash[:success] = "VLANs were successfully imported. #{params.to_s}"
    flash[:success] = "VLANs were successfully imported. option_id=#{params[:option_id]}, filename=#{params[:file].path}"
    Vlan.import(params[:file])
    @option_id = params[:option_id]
    @file_name = params[:filename]

    # Redirect to the index page to show the result
    redirect_to import_export_index_path 
  end

  def export
    flash[:success] = 'VLANs were successfully exported.'

    # Redirect to the index page to show the result
    redirect_to import_export_index_path 
  end

  def info
  end

end
