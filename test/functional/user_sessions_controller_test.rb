require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test "should not login a user that has not been confirmed" do
    user = users(:one)
    assert !user.confirmed

    post :create,
      :user_session => {
        :login => user.login,
        :password => 'password'
      }

    assert !flash[:error].nil?
    assert flash[:notice].nil?

  end

  test "should login a user that has been confirmed" do
    user = users(:one)
    assert !user.confirmed
    user.confirmed = true
    user.save!

    post :create,
      :user_session => {
        :login => user.login,
        :password => 'password'
      }

    assert flash[:error].nil?
    assert !flash[:notice].nil?

  end

  test "should activate user providing the token" do

    user = User.find_by_login :test_user_one
    assert !user.confirmed

    get :activation
    assert_response :success

    post :activate, {
      :authorization_token => user.perishable_token
    }
    assert_response :success

    user = User.find_by_login :test_user_one
    assert !user.confirmed

  end

end
