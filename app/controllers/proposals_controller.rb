class ProposalsController < ApplicationController

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
