require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', "Home | IPAMS"
    assert_select '#chart', count: 1
  end
end
