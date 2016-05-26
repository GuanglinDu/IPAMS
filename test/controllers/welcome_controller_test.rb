require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', "IPAMS"
    assert_select 'h3', "IPAMS Home Page"
  end
end
