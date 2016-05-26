require 'test_helper'

class AdminFlowsTest < ActionDispatch::IntegrationTest
  # Sign_in with devise: http://goo.gl/LfZqBz
  # devise creates form field names as
  #   'user[email]'
  #   'user[password]'
  test "a root browses the site" do
    tom = admins(:tom) # root tom
    get new_admin_session_path
    assert_template 'devise/sessions/new'

    post admin_session_path,
         admin: {email: tom.email, password: tom.password}
    # The following format is OK, too.
         #"admin[email]" => tom.email,
         #"admin[password]" =>tom.password
    assert_response :success
    #puts @response
    #assert_equal flash[:notice], "Signed in successfully."

    get root_path 
    puts @response
    assert_equal "/", path
    #assert_select 'h3', "IPAMS Home Page"

    #first_page_of_users = User.paginate(page: 1)
  end

  #test "an admin browses the site" do
  #  sign_in admins(:jerry) # admin
  #  get welcome_path
  #  assert_template 'welcome/index'
  #end
end
