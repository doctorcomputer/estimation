class SiteController < ApplicationController

#  def index
#    @search = Struct.new("Search", :query, :category_key).new("","")
#    @requests = Request.find_active
#  end

  def index
    @search = Struct.new("Search", :query, :category_key).new(params[:query],params[:category_key])
    if @search.query.blank?
      @requests = Request.find_active().where('category_id like :category_id', :category_id => @search.category_key)
    else
      @requests = Request.find_active().where("category_id like :category_id", :category_id => @search.category_key).where("title like ?", '%' + @search.query + '%')
    end
    render :index
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
      @proposal.request = @request
      @proposal.user = current_user
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
