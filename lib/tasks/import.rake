# See Intro to Rake by Shneems: https://www.youtube.com/watch?v=gR0YfJrg9pg
# Dependency task :environment which is a Rails rake task loading models, etc.

# Imports data to table lans, vlans, departments (IPAMS-specific)
# TODO: Importing should be availabe through the web UI.
namespace :import do
  # To contain the import result 
  IMPORT_LOG = "#{Rails.root}/tmp/IMPORT_LOG.txt" 

  desc "imports LANs data from a CVS file (IPAMS-specific)"
  task lans: :environment do
    require 'csv'
  
    # Opens the IMPORT_LOG.txt file
    log_file = File.open(IMPORT_LOG, "w")
   
    file_path = "#{Rails.root}/public/download/lans_importing_template.csv" 
    CSV.foreach(file_path, headers: true) do |row| # CSV::Row is part Array & part Hash
      h1 = row.to_hash # temporary hash
      
      note = "OK" # importing result
      # Determines whether the Lan exists. If yes, updates it;
      # Note: Using h1[:lan_name] leads to failing finding the lan_name from Hash h1!!!
      if Lan.exists? lan_name: h1["lan_name"]
        note = "OK. Updated!"
        l1 = Lan.find_by lan_name: h1["lan_name"]
        Lan.update l1.id, h1
      else # or, creates a new Lan
        new_lan = Lan.new(h1)
        if new_lan.valid?
          note = "OK. Newly created!"
          new_lan.save
        else
          #new_lan.errors[:lan_number].any?, "lan_number must not be blank"
          #new_lan.errors[:lan_name].any?, "lan_name must not be blank"
          #new_lan.errors[:lan_description].any?, "lan_description must not be blank"
          note = new_lan.errors.inspect # = to_s
        end
      end

      # Logs the result for each row
      #h1[:note] = note
      log_file.puts note
    end
    
    puts "*** LANs data imported!"
  end
end

