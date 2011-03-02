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

    # set all values
    @request = Request.new(params[:request])

    # set the owner to the current logged user
    @request.user = current_user

    # set the expiration date
    begin
      unless params[:expiration_date].blank?
        @request.expiration= DateTime.strptime(params[:expiration_date], "%d/%m/%Y")
      end
    rescue
      @request.expiration= nil
    end

    # set the new status
    if params[:store_action] == :save.to_s
      @request.status = :draft
    elsif params[:store_action] == :publish.to_s
      @request.status = :active
    else
      raise "Unknown value '#{params[:store_action]}' for parameter #{:store_action}"
    end

    # if eula is not checked for publication, show it
    @request.valid? #this is to trigger validation
    if(params[:store_action] == :publish.to_s && params[:eula]!=:accepted.to_s )
      @request.errors[:eula]= I18n.t('activerecord.errors.models.request.attributes.eula.should_be_checked_for_publication')
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
      return
    end

    if @request.save
      flash.now[:notice]= "La tua richiesta è stata memorizzata. Ricordati di attivarla."
      render :action => :new
      return
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
      return
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
    per_page = 5
    if params[:status] == :draft.to_s
      #@requests = Request.find_drafts current_user
      @requests = Request \
        .where('user_id = :user_id AND status = :status', :user_id => current_user.id, :status => :draft) \
        .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :active.to_s
      @requests = Request \
        .where('user_id = :user_id AND status=:status AND :now<expiration', :user_id => current_user.id, :status => :active, :now => DateTime.now) \
        .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :expired.to_s
      @requests = Request \
        .where('user_id = :user_id AND status=:status AND :now>=expiration', :user_id => current_user.id, :status => :active, :now => DateTime.now) \
        .paginate( :page => params[:page], :per_page => per_page )
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
    flash.now[:notice] = "Per la tua richiesta nessuna proposta è indicata come migliore."
    @request.proposals.each do |proposal|
      current_status = proposal.is_best
      next_status = (best_id.nil? || best_id.blank?) ? false : (best_id.to_s == proposal.id.to_s)
      if current_status != next_status
        proposal.is_best = next_status
        proposal.save
        if proposal.is_best 
          flash.now[:notice] = "La proposta di #{proposal.user.login} è ora la proposta migliore."
        end
      end
    end
    render :action => :new
  end

end
