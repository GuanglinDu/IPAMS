require 'test_helper'

# 1. Tests the controller with Pundit enables: http://goo.gl/qsRIVo
# 2. Signs in a user with Devise: http://goo.gl/djlwAJ 
class AdminsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "root should get index" do
    sign_in @tom # from Devise
    get :index
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  test "non-root should not get index" do
    sign_in @jerry # ditto
    get :index
    assert_response :redirect # 302

    sign_in @mary
    get :index
    assert_response :redirect # 302

    sign_in @barack
    get :index
    assert_response :redirect # 302

    sign_in @michelle
    get :index
    assert_response :redirect # 302

    sign_in @hillary
    get :index
    assert_response :redirect # 302
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin" do
    assert_difference('Admin.count') do
      post :create, admin: {email: "new_user_name@exmaple.com",
                            passowrd: "passowrd",
                            passowrd_confirmation: "passowrd"}
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
