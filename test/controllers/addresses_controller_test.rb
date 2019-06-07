require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  setup do
    @address = addresses(:one)
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index without searching keywords" do
    # The filter defaults to All
    get :index
    assert_response :success
    assert_not_nil assigns(:addresses)
    assert_select 'h4', "Listing IP Addresses"
    assert_select 'tr a', minimum: 2
    assert_select "tbody" do
      assert_select "tr", 3 # see fixture addresses.yml
    end
    assert_select "font", "10.0.0.1", count: 1 # Assigned 
    assert_select "font", "10.0.0.2", count: 1 # Assigned 
    assert_select "font", "10.0.0.3", count: 1 # Free 

    # The filter is set to Assigned
    get :index, {option: 'Assigned'} 
    assert_response :success
    assert_not_nil assigns(:addresses)
    assert_select "tbody" do
      assert_select "tr", 2 # see fixture addresses.yml
    end

    # The filter is set to Assigned
    get :index, {option: 'Free'} 
    assert_response :success
    assert_not_nil assigns(:addresses)
    assert_select "tbody" do
      assert_select "tr", 1 # see fixture addresses.yml
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:address)
  end

  test "should show address" do
    get :show, id: @address
    assert_response :success
    assert_not_nil assigns(:address)
    assert_not_nil assigns(:histories)
  end

  test "should get edit" do
    get :edit, id: @address
    assert_response :success
  end

  test "should update address" do
    patch :update, id: @address,
          address: {usage: @address.usage << "something appended"}
    assert_redirected_to addresses_path
  end

  test "should recycle address" do
    put :recycle, id: @address
    assert_response :success
    assert_equal "Address was successfully recycled.", flash[:success] 
  end
end
