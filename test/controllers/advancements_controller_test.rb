require 'test_helper'

class AdvancementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @advancement = advancements(:one)
  end

  test "should get index" do
    get advancements_url
    assert_response :success
  end

  test "should get new" do
    get new_advancement_url
    assert_response :success
  end

  test "should create advancement" do
    assert_difference('Advancement.count') do
      post advancements_url, params: { advancement: { robot_code: @advancement.robot_code } }
    end

    assert_redirected_to advancement_url(Advancement.last)
  end

  test "should show advancement" do
    get advancement_url(@advancement)
    assert_response :success
  end

  test "should get edit" do
    get edit_advancement_url(@advancement)
    assert_response :success
  end

  test "should update advancement" do
    patch advancement_url(@advancement), params: { advancement: { robot_code: @advancement.robot_code } }
    assert_redirected_to advancement_url(@advancement)
  end

  test "should destroy advancement" do
    assert_difference('Advancement.count', -1) do
      delete advancement_url(@advancement)
    end

    assert_redirected_to advancements_url
  end
end
