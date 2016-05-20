require 'test_helper'

class DepartmentsControllerTest < ActionController::TestCase
  setup do
    @department = departments(:one)
    @tom = admins(:tom) # root
    sign_in @tom
    #@jerry = admins(:jerry) # admin
    #sign_in @jerry
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:departments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create department" do
    assert_difference('Department.count', 1) do
      post :create, department: {dept_name: "Never used department",
                                 location: "I do not know"}
    end
    assert_redirected_to department_path(assigns(:department))
  end

  test "should show department" do
    get :show, id: @department
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @department
    assert_response :success
  end

  test "should update department" do
    patch :update, id: @department, department: {
      dept_name: @department.dept_name << "Added more"}
    assert_redirected_to department_path(assigns(:department))
  end

  test "should destroy department" do
    assert_difference('Department.count', -1) do
      delete :destroy, id: @department
    end
    assert_redirected_to departments_path
  end
end
