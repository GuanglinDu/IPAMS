require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  # All kinds of admins
  def setup
    @tom = admins(:tom)             # root
    @jerry = admins(:jerry)         # admin
    @mary = admins(:mary)           # expert
    @barack = admins(:barack)       # operator
    @michelle = admins(:michelle)   # guest
    @hillary = admins(:hillary)     # nobody 
    @to_delete = admins(:to_delete) # to be deleted in the test 
  end

  test "root should get index" do
    sign_in @tom # from Devise, root
    get :index
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  test "non-root should not get index" do
    sign_in @jerry # admin
    get :index
    assert_response :redirect # 302

    sign_in @mary # expert
    get :index
    assert_response :redirect # 302

    sign_in @barack # operator
    get :index
    assert_response :redirect # 302

    sign_in @michelle # guest
    get :index
    assert_response :redirect # 302

    sign_in @hillary # nobody
    get :index
    assert_response :redirect # 302
  end

  test "should update admin" do
    sign_in @tom # Only a root can update an admin's role

    patch :update,
          id: @hillary,
          admin: {role: "guest"}
    assert_redirected_to admins_path
  end

  test "should destroy admin" do
    sign_in @tom # Only a root can delete an admin

    assert_difference('Admin.count', -1) do
      delete :destroy, id: @to_delete
    end
    assert_redirected_to admins_path
  end
end
