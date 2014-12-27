require 'test_helper'

class ExportControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

 # test "should get export" do
 #   get :export
 #   assert_response :success
 # end

end
