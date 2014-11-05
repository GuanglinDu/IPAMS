require 'test_helper'

class VlansPerspectiveControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
