require 'test_helper'

class SystemUsersControllerTest < ActionController::TestCase
  setup do
    @system_user = system_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_user" do
    assert_difference('SystemUser.count') do
      post :create, system_user: { name: @system_user.name, passowrd: @system_user.passowrd }
    end

    assert_redirected_to system_user_path(assigns(:system_user))
  end

  test "should show system_user" do
    get :show, id: @system_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_user
    assert_response :success
  end

  test "should update system_user" do
    patch :update, id: @system_user, system_user: { name: @system_user.name, passowrd: @system_user.passowrd }
    assert_redirected_to system_user_path(assigns(:system_user))
  end

  test "should destroy system_user" do
    assert_difference('SystemUser.count', -1) do
      delete :destroy, id: @system_user
    end

    assert_redirected_to system_users_path
  end
end
