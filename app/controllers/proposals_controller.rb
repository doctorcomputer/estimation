class ProposalsController < ApplicationController

  def show
    
  end

  def index
    if params[:status] == :active.to_s
      @proposals = Proposal.find_active(current_user)
    elsif params[:status] == :expired.to_s
      @proposals = Proposal.find_expired(current_user)
    elsif params[:status] == :best.to_s
      @proposals = Proposal.find_best(current_user)
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
    @proposal.request_id = request.id
    @proposal.user_id = current_user
    if @proposal.save
      redirect_to request_path(request)
    end
  end

end
