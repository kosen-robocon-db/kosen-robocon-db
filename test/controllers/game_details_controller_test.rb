require 'test_helper'

class GameDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get game_details_index_url
    assert_response :success
  end

end
