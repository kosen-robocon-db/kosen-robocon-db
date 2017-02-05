require 'test_helper'

class ContestEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contest_entries_index_url
    assert_response :success
  end

  test "should get show" do
    get contest_entries_show_url
    assert_response :success
  end

end
