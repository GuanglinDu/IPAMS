namespace :address_order do
  desc "Calculates the IP address order number"
  task sort: :environment do
    addresses = Address.all
    sorted_addresses = Array.new
    addresses.each { |addr| sorted_addresses.push(addr.ip) }

    sorted_addresses = sorted_addresses.sort_by do |addr|
      addr.split('.').map{ |digits| digits.to_i }
    end

    sorted_addresses.each_with_index do |value, index|
      addr = Address.find_by(ip: value)
      addr.address_order = index
      addr.save
    end
  end
end
