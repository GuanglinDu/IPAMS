require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# 3.3 What to Include in Your Unit Tests
# Ideally, you would like to include a test for everything which could possibly break.
# It's a good practice to have at least one test for each of your validations
# and at least one test for every method in your model.
# See 4 Functional Tests for Your Controllers
class LansControllerTest < ActionController::TestCase
  # Load a Lan object from fixtures lans
  setup do
    @lan = lans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lans)

    # Verifies HTML elements <tr><td><a></a></td></tr>
    assert_select 'tr td a', minimum: 3 
    # Verifies class selectors btn, btn-primary, btn-xs
    assert_select '.btn', minimum: 2 
    assert_select '.btn-primary', minimum: 2 
    assert_select '.btn-xs', minimum: 2 
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # Tests action create. See lan.rb for lan_number, lan_name & lan_description validation
  test "should create lan" do
    assert_difference('Lan.count', 1, "A new Lan should be added to the test db") do
      # The following cannot work as it cannot pass the model validation
      #post :create, lan: { lan_description: @lan.lan_description, lan_name: @lan.lan_name, lan_number: @lan.lan_number }
      post :create, lan: { lan_description: 'Created by lans_controller_test.rb',
        lan_name: 'Unamed LAN', lan_number: Lan.count + 1 }
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

