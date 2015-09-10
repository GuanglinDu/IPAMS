namespace :update do
  desc "Updates the mac-address in addresses table(IPAMS-specific)"
  task macaddress: :environment do

    addresses = Address.all
    count_all = 0
    count12 = 0
    count14 = 0
    count17 = 0
    count_else = 0
    addresses.each do |addr|
      addr1 = addr.mac_address
      addr2 = addr.mac_address
      a1 = "==============================one==========================="
      puts a1
      #puts addr1
      #puts addr2
      #if addr1 != nil   
      if addr1 != nil && !(addr1 =~ /[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}/)   
        b1 = addr1.at(4)
        b2 = addr1.at(2)
        count_all += 1
        puts addr2
        if addr1.length == 12
          mac_new0 = addr1.at(0..3) + "-" +  addr1.at(4..7) + "-" + addr1.at(8..11) 
          addr.mac_address = mac_new0.upcase
          count12 += 1
        elsif addr1.length == 14 && b1 != "-"
        #elsif addr1.length == 14 && !(addr1 =~ /[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}/)
          #format_mac14(addr1)
          mac_new1 = addr1.at(0..3) + "-" +  addr1.at(5..8) + "-" + addr1.at(10..13) 
          #puts addr1.at(0..3) + "-" +  addr1.at(5..8) + "-" + addr1.at(10..13) 
          addr.mac_address = mac_new1.upcase
          puts addr1
          #addr.save
          count14 += 1
        elsif addr1.length == 17 && (addr1 =~/[A-Fa-f0-9]{2}-[A-Fa-f0-9]{2}-[A-Fa-f0-9]{2}-[A-Fa-f0-9]{2}-[A-Fa-f0-9]{2}-[A-Fa-f0-9]{2}/)
          #format_mac17(addr1)
          mac_new2 = addr1.at(0..1) + addr1.at(3..4) + "-" +  addr1.at(6..7) + addr1.at(9..10) + "-" +  addr1.at(12..13) + addr1.at(15..16) 
          #puts addr1.at(0..1) + addr1.at(3..4) + "-" +  addr1(6..7) + addr1(9..10) + "-" +  addr1(12..13) + addr1(15..16) 
          addr.mac_address = mac_new2.upcase
          puts addr1
          count17 += 1
        else 
          count_else += 1
          puts addr.ip + "'s MAC:  " +addr1+" is illegal!!!!!!!"
        end
      end
      addr.save
      puts addr.mac_address
   end

   puts "*** The mac-address attribute of #{count_all} addresses need to be formated."
   puts "*** The 12bit mac-address attribute of #{count12} addresses has been formated."
   puts "*** The 14bit mac-address attribute of #{count14} addresses has been formated."
   puts "*** The 17bit mac-address attribute of #{count17} addresses has been formated."
   puts "*** The illegal mac-address attribute of #{count_else} addresses has not been formated."

  end
end
