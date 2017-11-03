require 'test_helper'

class AdvancementHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @advancement_history = advancement_histories(:one)
  end

  test "should get index" do
    get advancement_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_advancement_history_url
    assert_response :success
  end

  test "should create advancement_history" do
    assert_difference('AdvancementHistory.count') do
      post advancement_histories_url, params: { advancement_history: { advancement_code: @advancement_history.advancement_code, robot_code: @advancement_history.robot_code } }
    end

    assert_redirected_to advancement_history_url(AdvancementHistory.last)
  end

  test "should show advancement_history" do
    get advancement_history_url(@advancement_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_advancement_history_url(@advancement_history)
    assert_response :success
  end

  test "should update advancement_history" do
    patch advancement_history_url(@advancement_history), params: { advancement_history: { advancement_code: @advancement_history.advancement_code, robot_code: @advancement_history.robot_code } }
    assert_redirected_to advancement_history_url(@advancement_history)
  end

  test "should destroy advancement_history" do
    assert_difference('AdvancementHistory.count', -1) do
      delete advancement_history_url(@advancement_history)
    end

    assert_redirected_to advancement_histories_url
  end
end
