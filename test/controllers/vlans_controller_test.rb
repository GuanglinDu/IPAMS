require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# See 4 Functional Tests for Your Controllers
class VlansControllerTest < ActionController::TestCase
  setup do
    @vlan = vlans(:one)
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vlans)

    # 4.6 Testing Templates and Layouts
    assert_template :index, "Should render template index.html.erb"
    assert_template layout: "layouts/application"
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

  test "should create vlan" do
    assert vlans(:one).valid?, "VLAN fixture one should be valid"
    assert_not_nil vlans(:one).lan_id,
                   "FK lan_id of fixture one should NOT be nil"
    assert_difference('Vlan.count', 1, "A new Vlan should be created") do
      post :create, vlan: {
        lan_id: vlans(:one).lan_id, # FK lan_id!
        vlan_number: Vlan.count + 1,
        vlan_name: 'Unamed VLAN',
        static_ip_start: '10.0.101.0',
        static_ip_end: '10.0.101.255',
        gateway: '10.0.101.254',
        subnet_mask: '255.255.255.0',
        vlan_description: 'Created by vlans_controller_test.rb'
      }
    end
    assert_redirected_to vlans_path
  end

  # Rails can automatically extract the id from the model object
  test "should show vlan" do
    get :show, id: @vlan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vlan
    assert_response :success
  end

  test "should update vlan" do
    patch :update, id: @vlan,
      vlan: {vlan_description: @vlan.vlan_description << "Added more by test"}
    assert_redirected_to vlan_path(assigns(:vlan))
  end

  test "should destroy vlan" do
    assert_difference('Vlan.count', -1) do
      delete :destroy, id: @vlan
    end
    assert_redirected_to vlans_path
  end
end
