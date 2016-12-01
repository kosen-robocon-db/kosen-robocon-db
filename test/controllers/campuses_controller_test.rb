require 'test_helper'

class CampusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get campuses_index_url
    assert_response :success
  end

  test "should get show" do
    get campuses_show_url
    assert_response :success
  end

end
