# http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
FactoryGirl.define do
  sequence :lan_number do |n|
    n
  end
 
  # Reuses the sequence result: http://goo.gl/Ct80r5
  # Use a block to access your current object.
  factory :lan do |la|
    lan_number
    lan_name { "Test-LAN-#{la.lan_number}" }
    # OK if the openning has no |la|
    #lan_name { |la| "Test-LAN-#{la.lan_number}" }
    lan_description "For test only"
  
    factory :lan_with_vlans do
      transient do
        vlan_count 5
      end
      
      after(:create) do |lan, evaluator|
        create_list(:vlan, evaluator.vlan_count, lan: lan)
      end
    end
  end
end
