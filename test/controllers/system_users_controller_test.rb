require 'test_helper'

class SystemUsersControllerTest < ActionController::TestCase
  setup do
    @tom = system_users(:tom)
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
      post :create, system_user: {name: @tom.name, passowrd: @tom.passowrd}
    end
    assert_redirected_to system_user_path(assigns(:system_user))
  end

  test "should show system_user" do
    get :show, id: @tom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tom
    assert_response :success
  end

  test "should update system_user" do
    patch :update, id: @tom,
      system_user: {name: @tom.name, passowrd: @tom.passowrd}
    assert_redirected_to system_user_path(assigns(:system_user))
  end

  test "should destroy system_user" do
    assert_difference('SystemUser.count', -1) do
      delete :destroy, id: @tom
    end
    assert_redirected_to system_users_path
  end
end
