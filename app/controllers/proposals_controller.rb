class ProposalsController < ApplicationController

  def show
    
  end

  def index
    per_page = 20

    #These proposals are related to requests that are not expired.
    if params[:status] == :active.to_s
      @title="Offerte in corso"
      @subtitle="Elenco di tutte le tue offerte relative a richieste non ancora scadute."
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where("#{Request.table_name}.status=:status", :status => :active) \
      .where(":now<#{Request.table_name}.expiration", :now => DateTime.now) \
      .includes(:request, :user) \
      .paginate( :page => params[:page], :per_page => per_page )
#    elsif params[:status] == :expired.to_s
#      @title="Offerte scadute"
#      @subtitle="Elenco di tutte le tue offerte relative a richieste non ancora scadute."
#      @proposals = Proposal \
#      .joins(:request) \
#      .where(Proposal.table_name => {:user_id => current_user.id}) \
#      .where("#{Request.table_name}.status=:status", :status => :active) \
#      .where(":now>=#{Request.table_name}.expiration", :now => DateTime.now) \
#      .includes(:request, :user) \
#      .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :best.to_s
      @title="Offerte migliori"
      @subtitle="Elenco delle tue offerte attualmente considerate come migliori. " \
        + "Ricordati che il committente ha tempo sino alla chiusura della richiesta " \
        + "per selezionare altre offerte come migliori."
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where("#{Request.table_name}.status=:status", :status => :active) \
      .where(":now<#{Request.table_name}.expiration", :now => DateTime.now) \
      .includes(:request, :user) \
      .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :awarded.to_s
      @title="Offerte aggiudicate"
      @subtitle="Elenco delle tue offerte che sono state considerate migliori. " \
        + "Clicca sulla richiesta per scoprire i contatti del committente ed " \
        + "entrare in contatto con lui."
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where("#{Request.table_name}.status=:status", :status => :active) \
      .where(":now>=#{Request.table_name}.expiration", :now => DateTime.now) \
      .includes(:request, :user) \
      .paginate( :page => params[:page], :per_page => per_page )
    elsif params[:status] == :rejected.to_s
      @title="Offerte non aggiudicate"
      @subtitle="Elenco delle tue offerte relative a richieste scadute che non sono state selezionate dal committente. "
      @proposals = Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => current_user.id}) \
      .where(Proposal.table_name => {:is_best => false}) \
      .where(["#{Request.table_name}.status=:status", {:status => :active}]) \
      .where([":now>=#{Request.table_name}.expiration", {:now => DateTime.now}]) \
      .includes(:request, :user) \
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
