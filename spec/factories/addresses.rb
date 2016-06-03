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
  end
end
