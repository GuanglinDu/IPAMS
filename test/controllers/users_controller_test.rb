require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @tom = admins(:tom) # root
    sign_in @tom
    #@jerry = admins(:jerry) # admin
    #sign_in @jerry
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post :create, user: {department_id: @user.department_id,
                           name: "Never.Used",
                           email: "never.used@example.com",
                           building: "The Unkonw",
                           storey: 10,
                           room: 1010,
                           cell_phone: 13912345678,
                           office_phone: 3456}
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: {office_phone: 99887766}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end
end
