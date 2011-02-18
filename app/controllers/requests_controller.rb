class RequestsController < ApplicationController

  def search
    
  end

  def search_old
    #@requests.where('description like :term and user_id not in :user_id')
  end

  def new
    @request = Request.new
  end

  def show
    @request = Request.find(params[:id])
    if @request.is_draft
      render :action => :new
    else
      @proposal = Proposal.new
      render :action => :new
    end
  end

  def create

    @request = Request.new(params[:request])
    @request.user = current_user
    if params[:store_action] == :save.to_s
      @request.status = :draft
    elsif params[:store_action] == :publish.to_s
      @request.status = :active
    else
      raise "Unknown value '#{params[:store_action]}' for parameter #{:store_action}"
    end
    begin
      unless params[:expiration_date].nil?
        @request.expiration= Date.strptime(params[:expiration_date], "%d/%m/%Y")
      end
    rescue
      @request.expiration= nil
    end

    if @request.save
      flash[:notice]= "La tua richiesta è stata memorizzata. Ricordati di attivarla."
      redirect_to :action => :new
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
  end

  def update
    @request = Request.find(params[:id])
    @request.user = current_user
    if params[:store_action] == :save.to_s
      @request.status = :draft
    elsif params[:store_action] == :publish.to_s
      @request.status = :active
    else
      raise "Unknown value '#{params[:store_action]}' for parameter #{:store_action}"
    end
    begin
      unless params[:expiration_date].nil?
        @request.expiration= Date.strptime(params[:expiration_date], "%d/%m/%Y")
      end
    rescue
      @request.expiration= nil
    end

    if @request.update_attributes(params[:request])
      flash[:notice]= "La tua richiesta è stata aggiornata."
      redirect_to :action => :new
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
  end

  def index
    if params[:status] == :draft.to_s
      @requests = Request.find_drafts current_user
    elsif params[:status] == :active.to_s
      @requests = Request.find_active current_user
    elsif params[:status] == :expired.to_s
      @requests = Request.find_expired current_user
    else
      raise "'#{:status}' parameter with value '#{params[:status]}' not recognized."
    end
  end

  def personal_index
    if(current_user!=nil)
      @user = current_user
    else
      render :action => :index
    end
  end

  def set_best_proposal
    @request = Request.find(params[:request_id])
    best_id = params[:proposal_id]
    @request.proposals.each do |proposal|
      current_status = proposal.is_best
      next_status = (best_id.nil? || best_id.blank?) ? false : (best_id.to_s == proposal.id.to_s)
      if current_status != next_status
        proposal.is_best = next_status
        proposal.save
      end
    end
    render :action => :new
  end

end
