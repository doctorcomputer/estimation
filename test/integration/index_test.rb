require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should browse the index page" do
    get "/"
    assert_response :success
  end

  test "should run a query without search term" do
    get "/index?query=&category_key=root.house"
    assert_response :success
  end

end
