require "test_helper"

class ItchesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get itches_create_url
    assert_response :success
  end
end
