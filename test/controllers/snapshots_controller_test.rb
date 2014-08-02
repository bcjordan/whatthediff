require 'test_helper'

class SnapshotsControllerTest < ActionController::TestCase
  test "should get trigger" do
    get :trigger
    assert_response :success
  end

end
