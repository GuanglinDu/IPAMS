FactoryGirl.define do
  sequence :vlan_number do |n|
    n
  end
 
  # Reuses the sequence result: http://goo.gl/Ct80r5
  # Use a block to access your current object.
  factory :vlan do |vl|
    vlan_number
    vlan_name        { "VLAN-#{vl.vlan_number}" }
    subnet_mask      "255.255.255.0"
    static_ip_start  { "192.168.#{vl.vlan_number}.0" }
    static_ip_end    { "192.168.#{vl.vlan_number}.255" }
    gateway          { "192.168.#{vl.vlan_number}.254" }
    vlan_description { "This is VLAN #{vl.vlan_number}" }
    lan # association

    #factory :vlan_with_addresses do
    #  transient do
    #    address_count = 10
    #  end

    #  after(:create) do |vlan, user, evaluator|
    #    create_list(:address, evaluator.address_count,
    #                vlan: vlan, user: user)
    #  end
    #end
  end
end
