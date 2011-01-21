require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should browse the index page" do
    get "/"
    assert_response :success
  end

end
