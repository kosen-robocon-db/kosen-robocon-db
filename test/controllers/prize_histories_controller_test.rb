require 'test_helper'

class PrizeHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get prize_histories_edit_url
    assert_response :success
  end

  test "should get update" do
    get prize_histories_update_url
    assert_response :success
  end

end
