namespace :update do
  desc "Updates the recyclable attribute in addresses table(IPAMS-specific)"
  task recyclable: :environment do
    addresses = Address.all
    nobody_id = User.find_by(name: 'NOBODY').id
    count = 0
    addresses.each do |addr|
      if addr.user_id == nobody_id
        addr.recyclable = false 
        count += 1
      else
        addr.recyclable = true
      end
      addr.save
    end

    puts "*** The recyclable attribute of #{count} addresses updated to false."
  end
end
