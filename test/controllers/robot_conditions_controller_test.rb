require 'test_helper'

class RobotConditionsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get robot_conditions_edit_url
    assert_response :success
  end

end
