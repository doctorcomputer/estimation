class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_user_session, :visited_request, :set_visited_request
  before_filter :statistics

  def statistics
    unless current_user.nil?
      @draft_requests_number = Request.find_drafts(current_user).count
      @expired_requests_number = Request.find_expired(current_user).count
      @active_requests_number = Request.find_active(current_user).count
      @active_proposals_number = Proposal.count_active(current_user)
      @expired_proposals_number = Proposal.count_expired(current_user)
      @best_proposals_number = Proposal.count_best(current_user)
    else
      @draft_requests_number = 0
      @expired_requests_number = 0
      @active_requests_number = 0
      @active_proposals_number = 0
      @expired_proposals_number = 0
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.record
  end

  def visited_request
    puts "*gets******************#{cookies[:request_id]}"
    unless cookies[:request_id].nil?
      return Request.find(cookies[:request_id])
    else
      return nil
    end
  end

  def set_visited_request request
    unless request.nil?
      puts ".puts....................#{request.id}"
      cookies[:request_id] = request.id
    end
  end

  def user_tag user
    unless user.nil?
      return user.login
    else
      return ""
    end
  end

end
