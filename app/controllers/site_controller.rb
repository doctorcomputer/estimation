class SiteController < ApplicationController

  def index
    @requests = Request.find_active
  end

  def how_it_works    
  end

  def request_detail
    @request = Request.find params[:id]
    set_visited_request(@request)
  end

  #proposal_new/:id
  def proposal_new
    request = Request.find(params[:id])
    if ensure_login(request)
      @request = Request.find params[:id]
      @proposal = Proposal.new
      @proposal.request = @request
    end
  end

  def proposal_submission

    # If the user is logged in, then the proposal is saved else he's required to login.
    # The id of the request he was currently watching is saved.
    if current_user
      @request = Request.find params[:request][:id]
      if @request.nil?
        raise "Requst with id #{params[:request][:id]} not found"
      end
      @proposal = Proposal.new(params[:proposal])
      @proposal.request_id = @request.id
      @proposal.user_id = current_user
      if @proposal.save
        flash.now[:notice]='La tua offerta è stata registrata con successo. Puoi ora tenerla sotto controllo nella tua area personale'
        render :request_detail
      end
    else
      render :require_login
    end
  end

  private

  def ensure_login(request=nil)
    unless request.nil?
      set_visited_request(@request)
    end
    if current_user.nil?
      render :require_login
      return false
    else
      return true
    end
  end
  
end
