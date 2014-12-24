require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# 3.3 What to Include in Your Unit Tests
# Ideally, you would like to include a test for everything which could possibly break.
# It's a good practice to have at least one test for each of your validations
# and at least one test for every method in your model.
# See 4 Functional Tests for Your Controllers
class VlansControllerTest < ActionController::TestCase
  # Load a Vlan object from fixtures vlans
  setup do
    @vlan = vlans(:one)
  end

  # 4.3 The Four Hashes of the Apocalypse
  # Can't use assigns[:something] for historical reasons, use assigns(:something), instead
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vlans)

    # 4.6 Testing Templates and Layouts
    assert_template :index, "Should render template index.html.erb"
    # Cannot work with a message?
    #assert_template layout: "layouts/application", "Should render tempate layouts/application.html.erb"
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

  # Tests action create. Takes the FK from fixture one
  test "should create vlan" do
    # Makes sure that fixture one is valid
    assert vlans(:one).valid?, "VLAN fixture one should be valid"

    # Makes sure the FK is valid (not nil)
    assert_not_nil vlans(:one).lan_id, "FK lan_id of fixture one should NOT be nil"
    # Tests that all the attributes are valid to make sure the creating will be successful
    # The parenthesises () cannot be ommitted!
    #new_vlan = Vlan.new(
    #    lan_id: vlans(:one).lan_id, # FK lan_id
    #    vlan_number: Vlan.count + 1, # Makes unique
    #    vlan_name: 'Unamed VLAN',
    #    static_ip_start: '10.0.101.0',
    #    static_ip_end: '10.0.101.255',
    #    gateway: '10.0.101.254',
    #    subnet_mask: '255.255.255.0',
    #    vlan_description: 'Created by vlans_controller_test.rb')
    #assert new_vlan.valid?, "This new_vlan should be valid"

    # create = new + save
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

  # Rails can automatically extract id from its model object?
  test "should show vlan" do
    get :show, id: @vlan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vlan
    assert_response :success
  end

  # Appends some string to vlan_description & only updates it!
  test "should update vlan" do
    patch :update, id: @vlan, vlan: {
     # lan_id: @vlan.lan_id, # FK lan_id!
     # vlan_number: @vlan.vlan_number,
     # vlan_name: @vlan.vlan_name,
     # static_ip_start: @vlan.static_ip_start,
     # static_ip_end: @vlan.static_ip_end,
     # gateway: @vlan.gateway,
     # subnet_mask: @vlan.subnet_mask,
      vlan_description: @vlan.vlan_description << "Added more by test"
    }
 
    # 4.3 The Four Hashes of the Apocalypse
    # Can't use assigns[:something] for historical reasons, use assigns(:something), instead
    assert_redirected_to vlan_path(assigns(:vlan))
  end

  test "should destroy vlan" do
    assert_difference('Vlan.count', -1) do
      delete :destroy, id: @vlan
    end

    assert_redirected_to vlans_path
  end
end

