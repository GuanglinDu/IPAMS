require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  setup do
    @address = addresses(:one)
    sign_in admins(:tom) # root
    #sign_in admins(:jerry) # admin
  end

  test "should get index" do
    get :index 
    assert_response :success
    assert_nil assigns(:results)
    assert_select "h4", "Oooooops, nothing to search for!"
  end

  # FIXME: LoadError: Unable to autoload constant PaginatedCollectionPolicy
  #test "should search for something" do
  #  get :index, {search: "lan"}, nil, nil
  #  assert_response :success
  #  assert assigns(:results)
  #  assert_select "tr", minimum: 3
  #end
end
