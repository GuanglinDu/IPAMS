#require_relative 'utils'

# TODO: how to pass the prefix so that IP addresses correspond to its VLAN.
FactoryGirl.define do
  prefix = "192.168.0."

  sequence :ip do |n|
    "#{prefix}#{n}"
  end

  factory :address do
    ip
    #mac_address { create_mac_address }
    vlan # association, FK
    user # association, FK

    #transient do
    #  ip_prefix "192.168.0."
    #  @prefix = ip_prefix
    #end
 
    factory :address_with_histories do
      transient do
        history_count 2
      end
      
      after(:create) do |address, evaluator|
        create_list(:history, evaluator.history_count, address: address)
      end
    end
  end
end
