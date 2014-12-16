require 'test_helper'

class ImportExportControllerTest < ActionController::TestCase
  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get export" do
    get :export
    assert_response :success
  end

end
