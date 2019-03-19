require 'spec_helper'
require 'rails_helper'

feature "The whole website", :devise do
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

    # Shows a single IP address
    find_link("Show", match: :first).click
    expect(page).to have_content("Show the history of this IP address")

    # Tests the Histories view
    FactoryGirl.create :address_with_histories, vlan: vlan1, user: user1
    click_link "Histories"
    expect(page).to have_content("Show the history of all IP addresses")
    expect(page).to have_content("Displaying all 2 History")
    expect(page).to have_content("PC-office", minimum: 2)

    # Searches for something on the Search view
    click_link "Search"
    expect(page).to have_content("Oooooops, nothing to search for!")
    # FIXME: Unable to autoload constant PaginatedCollectionPolicy
    #fill_in 'search', with: 'lan'
    #click_button 'Global Search'
    #expect(page).to have_content("Test-LAN")
    #expect(page).to have_content("VLAN-1")

    # Goes back to the addresses view
    #click_link "Addresses"
    # Recycles an IP address
    #find_button("Recycle", match: :first).click
    # Goes to the Histories view to check
    #click_link "Histories"
  end
end
