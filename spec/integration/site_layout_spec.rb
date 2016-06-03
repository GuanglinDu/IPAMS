require 'spec_helper'
require 'rails_helper'

feature "The site layout", :devise do
  scenario "A root browses" do
    @admin = FactoryGirl.create :admin, :root
    sign_in @admin.email, @admin.password
    expect(page).to have_content("IPAMS Home Page")
    expect(page).to have_content("Sign out")
   
    #lan1 = FactoryGirl.create :lan
    #lan2 = FactoryGirl.create :lan
    FactoryGirl.create :lan_with_vlans
    FactoryGirl.create :lan_with_vlans
    click_link "LANs" # two LANs with 5 VLANs each
    expect(page).to have_content("Listing LANs")
    expect(page).to have_content("Displaying all 2 Lan")
    #find_link("Show", match: :first).click # OK
    click_link("Show", match: :first)
    expect(page).to have_content("The Current LAN")
    expect(page).to have_content("Displaying all 5 Vlan")

    click_link "VLANs"
    expect(page).to have_content("Listing VLANs")
    expect(page).to have_content("Displaying all 10 Vlan")

    FactoryGirl.create :department_with_users
    FactoryGirl.create :department_with_users
    click_link "Departments"
    expect(page).to have_content("Listing Departments")
    expect(page).to have_content("Displaying all 2 Department")

    click_link "Users"
    expect(page).to have_content("Listing Users")
    expect(page).to have_content("Displaying all 6 User")

    vlan1 = Vlan.first
    user1 = User.first
    # 1 + 10 = 11 IP addresses
    addr1 = FactoryGirl.create :address, vlan: vlan1, user: user1
    addr10 = FactoryGirl.create_list :address, 10, vlan: vlan1, user: user1
    click_link "Addresses"
    expect(page).to have_content("Listing IP Addresses")
    expect(page).to have_content("Displaying all 11 Address")
  end
end
