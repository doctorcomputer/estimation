class SiteController < ApplicationController

  def index
    @requests = Request.find_active
  end

  def how_it_works    
  end

  def request_detail
    @request = Request.find params[:id]
    @proposal = Proposal.new
    set_visited_request(@request)
  end

  def proposal_submission

    # If the user is logged in, then the proposal is saved else he's required to login.
    # The id of the request he was currently watching is saved.
    if current_user
      request = Request.find params[:request][:id]
      @proposal = Proposal.new(params[:proposal])
      @proposal.request_id = request.id
      @proposal.user_id = current_user
      if @proposal.save
        redirect_to request_path(request)
      end
    else
      render :require_login
    end
  end

  def personal_index
    if(current_user!=nil)
      @user = current_user
    else
      render :action => :index
    end
  end
  
end
