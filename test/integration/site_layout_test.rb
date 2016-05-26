require 'test_helper'

# See http://goo.gl/F1MKTg
class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get admin_session_path
    #assert_response :success
    assert 200, status # OK, too

    tom = admins(:tom)
    post admin_session_path,
         admin: {email: tom.email, password: tom.password}
    assert 200, status # OK, too
    # 10.2 The response Object, http://goo.gl/8xWWio
    #puts "\n\n#{@response.status}\n\n" # 200
    #assert_equal "/", path
    puts "session: #{session}"
  end
end
