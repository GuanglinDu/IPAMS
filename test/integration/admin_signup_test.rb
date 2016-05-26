require 'test_helper'

class AdminSignupTest < ActionDispatch::IntegrationTest
  test "valid signup" do
    get new_admin_registration_path
    assert_difference('Admin.count', 1) do
      post_via_redirect admin_registration_path,
                        admin: {email: "test_user@example.com",
                                password: "password",
                                password_confirmation: "password"}
    end

    assert_template 'welcome/index'
    assert_select 'strong', 1 
  end

  test "invalid signup" do
    get new_admin_registration_path
    assert_no_difference('Admin.count') do
      post_via_redirect admin_registration_path,
                        admin: {email: "test_user@example.com",
                                password: "password",
                                password_confirmation: "incorrect"}
    end
    assert_template 'devise/registrations/new'
  end
end
