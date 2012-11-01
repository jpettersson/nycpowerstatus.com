require 'test_helper'

class PowerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get area" do
    get :area
    assert_response :success
  end

end
