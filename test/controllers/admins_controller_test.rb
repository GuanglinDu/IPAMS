require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  setup do
    @tom = admins(:tom)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin" do
    assert_difference('Admin.count') do
      post :create, admin: {name: @tom.name, passowrd: @tom.passowrd}
    end
    assert_redirected_to admin_path(assigns(:admin))
  end

  test "should show admin" do
    get :show, id: @tom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tom
    assert_response :success
  end

  test "should update admin" do
    patch :update,
          id: @tom,
          admin: {name: @tom.name, passowrd: @tom.passowrd}
    assert_redirected_to admin_path(assigns(:admin))
  end

  test "should destroy admin" do
    assert_difference('Admin.count', -1) do
      delete :destroy, id: @tom
    end
    assert_redirected_to admins_path
  end
end
