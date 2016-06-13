require 'spec_helper'
require 'rails_helper'

# https://github.com/jnicklas/capybara
# http://goo.gl/F1MKTg
# https://robots.thoughtbot.com/rspec-integration-tests-with-capybara
feature "admin signing up", :devise do
  scenario "with valid email and password" do
    sign_up_with "nonexistent@example.com", "password", "password"
    expect(page).to have_content("Sign out")
    expect(page).to have_content("You have signed up successfully.")
    # Admin nobody's role has to be elevated to browse the site
    expect(page).to have_content("You must ask the administrator to assign" \
                                 " your role to dive deep.")
  end

  scenario "with invalid email" do
    sign_up_with "invalid_email", "password", "password"
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Sign up')
  end

  scenario "with blank password" do
    sign_up_with "valid@example.com", "", ""
    expect(page).to have_content("Sign in")
    expect(page).to have_content('Sign up')
  end

  # Defines the helpers in spec/support/helpers/session_helpers.rb,
  # and use spec/support/helpers/helpers.rb to load it
  #def sign_up_with(email, password)
  #  visit new_admin_registration_path
  #  #visit "/admins/sign_up" # same as the above
  #  fill_in 'Email', with: email
  #  fill_in 'Password', with: password
  #  fill_in 'Password confirmation', with: password
  #  click_button 'Sign up'
  #end
end
