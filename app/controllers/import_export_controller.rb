class ImportExportController < ApplicationController
  # Import/export based on CSV format
  require 'csv'

  # Entry to importing/exporting
  def index
  end

  def import
    #flash[:success] = "VLANs were successfully imported. option_id=#{params[:option_id]}, filename=#{params[:file].path}"
    option_id = params[:option_id]
    file_name = params[:filename]
    
    if params[:file]
      flash[:success] = "VLANs were successfully imported. #{params.to_s}"
      if option_id == "IP Addresses"
        #Address.import(params[:file])
        # Redirect to the VLANs page to show the result
        redirect_to addresses_path 
      else # VLANs 
        #Vlan.import(params[:file])
        # Redirect to the VLANs page to show the result
        redirect_to vlans_path 
      end      
    else
      flash[:failure] = "VLANs were NOT imported as no valid CSV file selected. #{params.to_s}"
      redirect_to import_export_index_path 
    end
  end

  def export
    flash[:success] = 'VLANs were successfully exported.'

    # Redirect to the index page to show the result
    redirect_to import_export_index_path 
  end

  def info
  end

  # Templates downloading
  def vlan_importing_template
    send_file(
      "#{Rails.root}/public/download/vlan_importing_template.csv",
        filename: "vlan_importing_template.csv",
        type: "application/pdf/docx/html/htm/doc"
    )
  end

  def ip_address_importing_template
    send_file(
      "#{Rails.root}/public/download/ip_address_importing_template.csv",
        filename: "ip_address_importing_template.csv",
        type: "application/pdf/docx/html/htm/doc"
    )
  end

  private
    
    # Dissect the data to Vlan, Department, User, Address object to import, respectivly
    def dissect_to_record_hashes
    end
end
