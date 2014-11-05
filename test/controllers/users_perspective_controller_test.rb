require 'test_helper'

class UsersPerspectiveControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
