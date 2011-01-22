require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should browse the registration page" do
    get "/users/new"
    assert_response :success
  end

end