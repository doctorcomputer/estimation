class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_user_session
  before_filter :statistics

  def statistics
    unless current_user.nil?
      @draft_requests_number = Request.where(:status => :draft).count
      @expired_requests_number = Request.where(:status => :expired).count
      @active_requests_number = Request.where(:status => :active).count
    else
      @draft_requests_number = 0
      @expired_requests_number = 0
      @active_requests_number = 0
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.record
  end
end
