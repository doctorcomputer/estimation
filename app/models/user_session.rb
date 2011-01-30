class UserSession < Authlogic::Session::Base
  login_field :login
  #find_by_login_method :find_by_verified_login
end
