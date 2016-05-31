require 'spec_helper'
require 'rails_helper'

feature "The site layout", :devise do
  scenario "A root browses" do
    @admin = FactoryGirl.create :admin, :root
    sign_in @admin.email, @admin.password
    expect(page).to have_content("IPAMS Home Page")
    expect(page).to have_content("Sign out")
    
    click_link "LANs"
    expect(page).to have_content("Listing LANs")
    #expect(page).to have_content("Displaying Lan")
    #expect(page).to have_selector("a", first: "btn btn-primary btn-xs")
    #find(".btn .btn-primary .btn-xs", text: "Show", match: :first).click
    find("#main-table-body").click
    #find_link("Show", match: :first).click
    #click_link("Show", match: :first)
    #expect(page).to have_content("The Current LAN")

    click_link "VLANs"
    expect(page).to have_content("Listing VLANs")
    click_link "Addresses"
    expect(page).to have_content("Listing IP Addresses")
    click_link "Departments"
    expect(page).to have_content("Listing Departments")
    click_link "Users"
    expect(page).to have_content("Listing Users")
  end
end
