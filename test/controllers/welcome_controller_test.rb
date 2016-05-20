require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    @tom = admins(:tom) # root
    sign_in @tom
    #@jerry = admins(:jerry) # admin
    #sign_in @jerry
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', "IPAMS"
    assert_select 'h3', "IPAMS Home Page"
  end
end
