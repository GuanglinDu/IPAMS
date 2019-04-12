require 'test_helper'

# See 4 Functional Tests for Your Controllers
# at http://guides.rubyonrails.org/testing.html
class LansControllerTest < ActionController::TestCase
  setup do
    sign_in admins(:tom)   # root
    #sign_in admins(:jerry) # admin
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

  test "should create lan" do
    assert_difference("Lan.count", 1,
                      "A new Lan should be added to the test db") do
      post :create, lan: {
        lan_number: Lan.count + 1,
        lan_name: "Unamed LAN",
        lan_description: "Created by lans_controller_test.rb"
      }
    end
    assert_redirected_to lan_path(assigns(:lan))
  end

  test "should show lan" do
    get :show, id: lans(:one)
    assert_response :success
    assert_not_nil assigns(:lan)
    assert_not_nil assigns(:vlans_of_lan)
  end

  test "should get edit" do
    get :edit, id: lans(:one)
    assert_response :success
  end

  test "should update lan" do
    lan = lans(:one)
    patch :update, id: lan, lan: {
      lan_description: "A changed LAN description",
      lan_name: lan.lan_name,
      lan_number: lan.lan_number
    }
    assert_redirected_to lan_path(assigns(:lan))
  end

  test "should destroy lan" do
    lan = lans(:three)
    assert_difference('Lan.count', -1) do
      delete :destroy, id: lan
    end
    assert_redirected_to lans_path
  end
end
