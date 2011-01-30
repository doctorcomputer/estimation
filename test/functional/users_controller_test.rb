require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
  end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:users)
#  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do

    assert_difference('User.count') do
      post :create, {
        :user => {
          :login => 'user',
          :password => 'password',
          :password_confirmation => 'password',
          :email => 'user@test.zu',
          :first_name => 'first_name',
          :last_name => 'last_name',
          :address => 'address',
          :zip => '99999',
          :city => 'Metropolis',
          :is_professional => 'false',
          :eula => '1',
          :privacy => '1'
        },
        :email_confirmation => 'user@test.zu'
      }
    end

    user = User.find_by_login('user')
    assert_not_nil user
    assert !user.confirmed
  end

  test "should not create user if email does not match" do

    assert_difference('User.count', 0) do
      post :create, {
        :user => {
          :login => 'user',
          :password => 'password',
          :password_confirmation => 'password',
          :email => 'user@test.zu',
          :first_name => 'first_name',
          :last_name => 'last_name',
          :address => 'address',
          :zip => '99999',
          :city => 'Metropolis',
          :is_professional => 'false',
          :eula => '1',
          :privacy => '1'
        },
        :email_confirmation => 'wrong'
      }
    end

    user = User.find_by_login('user')
    assert_nil user
  end

  test "should not create user if passwords do not match" do

    assert_difference('User.count', 0) do
      post :create, {
        :user => {
          :login => 'user',
          :password => 'password',
          :password_confirmation => 'passwordwrong',
          :email => 'user@test.zu',
          :first_name => 'first_name',
          :last_name => 'last_name',
          :address => 'address',
          :zip => '99999',
          :city => 'Metropolis',
          :is_professional => 'false',
          :eula => '1',
          :privacy => '1'
        },
        :email_confirmation => 'user@test.zu'
      }
    end

    user = User.find_by_login('user')
    assert_nil user
  end
  
  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

#  test "should get edit" do
#    get :edit, :id => @user.to_param
#    assert_response :success
#  end

#  test "should update user" do
#    put :update, :id => @user.to_param, :user => @user.attributes
#    assert_redirected_to user_path(assigns(:user))
#  end

#  test "should destroy user" do
#    assert_difference('User.count', -1) do
#      delete :destroy, :id => @user.to_param
#    end
#
#    assert_redirected_to users_path
#  end
end
