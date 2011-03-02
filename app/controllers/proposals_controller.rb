class ProposalsController < ApplicationController

  def show
    
  end

  def index
    per_page = 20
    if params[:status] == :active.to_s
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(["#{Request.table_name}.status=:status AND :now<#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}]) \
      .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :expired.to_s
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(["#{Request.table_name}.status=:status AND :now>=#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}]) \
      .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :best.to_s
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where(["#{Request.table_name}.status=:status AND :now>=#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}]) \
      .paginate( :page => params[:page], :per_page => per_page )
    else
      raise "'#{:status}' parameter with value '#{params[:status]}' not recognized."
    end
  end

  def new
    @proposal = Proposal.new
  end

  def create

    request = Request.find params[:request][:id]

    @proposal = Proposal.new(params[:proposal])
    @proposal.request = request
    @proposal.user = current_user
    if @proposal.save
      redirect_to request_path(request)
    end
  end

end
