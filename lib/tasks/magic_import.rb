# Generic importing implementation supporting one-layered FK relation
module MagicImport
  require 'csv'

  # To contain the import result 
  IMPORT_LOG = "#{Rails.root}/tmp/IMPORT_LOG.txt" 

  def import(csv_file_path = "", uk_name = nil, fks = [], tables = {parent_table: nil, child_table: nil})
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
   
    # Validates the file 
    csv_file_path ||= "" # if nil, assign ""
    unless File.exists?(csv_file_path)
      log_file.puts "ERROR: CSV file is either nil or non-existent"
      return
    end

    CSV.foreach(cvs_file_path, headers: true) do |raw_row| # CSV::Row is part Array & part Hash
      h1 = strip_whitespace(raw_row) # temporary hash

      note = "OK" # importing result
      # Determines whether the Department exists. If yes, updates it;
      # Note: Using h1[:dept_name] leads to failing finding the dept_name from Hash h1!!!
      if Department.exists? dept_name: h1["dept_name"]
        note = "OK. Updated!"
        d1 = Department.find_by dept_name: h1["dept_name"]
        Department.update d1.id, h1
      else # or, creates a new Department
        new_dept = Department.new(h1)
        if new_dept.valid?
          note = "OK. Newly created!"
          new_dept.save
        else
          note = new_dept.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      log_file.puts note
    end
    
    puts "*** Departments imported!"
  end

  # Strips the whitespaces from both the key and the value
  def strip_whitespace(raw_row = {})
    row = {}
    raw_row.each{|k, v| row[k.strip] = v.strip}
    row.to_hash
  end
end
