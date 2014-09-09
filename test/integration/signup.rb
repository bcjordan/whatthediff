require '../test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  test "visit front page" do
    get root_url
    assert_response :success
  end
end
