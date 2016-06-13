require 'test_helper'

class HistoriesControllerTest < ActionController::TestCase
  setup do
    #@address = addresses(:one)
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:histories)
    assert_select 'h3', "Show the history of all IP addresses"
    assert_select 'tr th', "MAC Address"
  end

  test "should create" do
    assert_difference('History.count', 1) do
      #post :create, histories_path, history: {address_id: addresses(:one).id,
      #                                        usage: "Office laptop"}
      post :create, histories_path, address_id: addresses(:one).id
    end
    assert_response :success
    assert_not_nil assigns(:history)
  end
end
