class SiteController < ApplicationController

  def index

    query = params[:query].nil? ? "" : params[:query]
    category_key = params[:category_key].nil? ? "" : params[:category_key]
    @search = Struct.new("Search", :query, :category_key).new(query,category_key)

    sorting = {
      'expiring_asc' => 'expiration asc',
      'published_desc' => 'updated_at desc',
      nil => 'expiration asc'
    }

    if @search.query.blank?
      @requests = Request \
        .where('status=:status AND :now<expiration', :status => :active, :now => DateTime.now) \
        .where('category_id like :category_id', :category_id => "#{@search.category_key}%") \
        .order(sorting[params[:sorting]]) \
        .paginate( :page => params[:page], :per_page => 10 )
    else
      @requests = Request \
        .where('status=:status AND :now<expiration', :status => :active, :now => DateTime.now) \
        .where("category_id like :category_id", :category_id => "#{@search.category_key}%") \
        .where("title like ?", '%' + @search.query + '%') \
        .order(sorting[params[:sorting]]) \
        .paginate( :page => params[:page], :per_page => 10 )
    end

    render :index
  end

  def request_detail
    @request = Request.find params[:id]
    set_visited_request(@request)
  end

  # Called when user want to submit a new proposal.
  # proposal_new/:id
  def proposal_new
    request = Request.find(params[:id])
    if ensure_login(request)
      @request = request
      @proposal = Proposal.new
      @proposal.request = @request
    end
  end

  def proposal_submission

    # If the user is logged in, then the proposal is saved else he is required
    # to login.
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

        #TenderMailer.tender_new_proposal_for_request_owner_email(@request, @proposal).deliver
        TenderMailer.delay.tender_new_proposal_for_request_owner_email(@request, @proposal)

        flash.now[:notice]='La tua offerta è stata registrata con successo. Puoi ora tenerla sotto controllo nella tua area personale'
      else
        flash.now[:error]='La tua offerta non è stata salvata'
      end
      render :action => :request_detail
    else
      render :require_login
    end
  end

  private

  def ensure_login(request=nil)
    unless request.nil?
      set_visited_request(request)
    end
    if current_user.nil?
      render :require_login
      return false
    else
      return true
    end
  end
  
end
