require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get samples" do
    get :samples
    assert_response :success
  end

end
