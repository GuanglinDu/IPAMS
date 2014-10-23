require 'test_helper'

class LansControllerTest < ActionController::TestCase
  setup do
    @lan = lans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lan" do
    assert_difference('Lan.count') do
      post :create, lan: { lan_description: @lan.lan_description, lan_name: @lan.lan_name, lan_number: @lan.lan_number }
    end

    assert_redirected_to lan_path(assigns(:lan))
  end

  test "should show lan" do
    get :show, id: @lan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lan
    assert_response :success
  end

  test "should update lan" do
    patch :update, id: @lan, lan: { lan_description: @lan.lan_description, lan_name: @lan.lan_name, lan_number: @lan.lan_number }
    assert_redirected_to lan_path(assigns(:lan))
  end

  test "should destroy lan" do
    assert_difference('Lan.count', -1) do
      delete :destroy, id: @lan
    end

    assert_redirected_to lans_path
  end
end
