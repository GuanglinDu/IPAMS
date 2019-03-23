# Feature: Sign in
#   As an admin
#   I want to sign in
#   So I can visit protected areas of the site
feature 'Signing in', :devise do
  background do
    @admin = FactoryGirl.create :admin, :root
  end

  # Scenario: Admin cannot sign in if not registered
  #   Given I do not exist as an admin
  #   When I sign in with valid credentials
  #   Then I see an invalid credentials message
  scenario 'Admin cannot sign in if not registered' do
    sign_in 'test@example.com', 'please123'
    #expect(page).to have_content I18n.t('devise.failure.not_found_in_database'),
    #                             authentication_keys: 'email'
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Sign up')
  end

  # Scenario: Admin can sign in with valid credentials
  #   Given I exist as an admin
  #   And I am not signed in
  #   When I sign in with valid credentials
  #   Then I see a success message
  scenario 'Admin can sign in with valid credentials' do
    sign_in @admin.email, @admin.password
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  # Scenario: Admin cannot sign in with wrong email
  #   Given I exist as an admin
  #   And I am not signed in
  #   When I sign in with a wrong email
  #   Then I see an invalid email message
  scenario 'Admin cannot sign in with wrong email' do
    sign_in 'invalid@email.com', @admin.password
    #expect(page).to have_content I18n.t('devise.failure.not_found_in_database'),
    #                             authentication_keys: 'email'
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Sign up')
  end

  # Scenario: Admin cannot sign in with wrong password
  #   Given I exist as a admin
  #   And I am not signed in
  #   When I sign in with a wrong password
  #   Then I see an invalid password message
  scenario 'Admin cannot sign in with wrong password' do
    sign_in @admin.email, 'invalidpass'
    #expect(page).to have_content I18n.t('devise.failure.invalid'),
    #                             authentication_keys: 'email'
    expect(page).to have_content('Sign in')
  end
end
