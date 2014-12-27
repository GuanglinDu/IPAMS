class ExportController < ApplicationController
  # Export based on CSV format
  require 'csv'

  # Entry to exporting
  def index
  end

  def export
    flash[:success] = 'VLANs were successfully exported.'

    # Redirect to the index page to show the result
    redirect_to export_index_path 
  end

  def info
  end
end
