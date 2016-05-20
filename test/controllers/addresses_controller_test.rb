require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  setup do
    @address = addresses(:one)
    @tom = admins(:tom) # root
    sign_in @tom
    #@jerry = admins(:jerry) # admin
    #sign_in @jerry
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:addresses)
    assert_select 'h4', "Listing IP Addresses"
    assert_select 'tr a', minimum: 2
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
    patch :recycle, id: @address
    assert_response :success
    assert_equal "Address was successfully recycled.", flash[:success] 
  end
end
