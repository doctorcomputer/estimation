require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should browse the registration page" do
    get "/users/new"
    assert_response :success
  end

  test "should register a new user" do
    get "/users/new"
    assert_response :success

    post_via_redirect "/users", {
      'user[login]' => 'user',
      'user[password]' => 'password',
      'user[password_confirmation]' => 'password',
      'user[email]' => 'user@test.zu',
      'email_confirmation' => 'user@test.zu',
      'user[first_name]' => 'first_name',
      'user[last_name]' => 'last_name',
      'user[address]' => 'address',
      'user[zip]' => '99999',
      'user[city]' => 'Metropolis',
      'user[is_professional]' => 'false',
      'user[eula]' => '1',
      'user[privacy]' => '1'
    }

    assert_equal '/users', path
    assert_equal 'Riceverai una mail di attivazione.', flash[:notice]
    
  end

end