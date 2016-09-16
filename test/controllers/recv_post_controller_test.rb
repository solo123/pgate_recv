require 'test_helper'

class RecvPostControllerTest < ActionDispatch::IntegrationTest
  setup do
  end

  test "post to notify url" do
    post recv_notify_url, params: { a_fld: 'a field', b_fld: 'b field' }
    assert_response :success
  end
end
