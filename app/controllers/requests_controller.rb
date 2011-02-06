class RequestsController < ApplicationController

  def new
    @request = Request.new
  end

  def show
    @request = Request.find(params[:id])
    render :action => :new
  end

  def create

    @request = Request.new(params[:request])
    @request.user = current_user
    if(params[:action]==:save)
      @request.status = :draft
    else
      @request.status = :active
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
      redirect_to :controller => :home,  :action => :personal_index
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
  end

  def index
    if params[:status] == :draft.to_s
      @requests = Request.where(:status => :draft)
    elsif params[:status] == :active.to_s
      @requests = Request.where('status=:status AND :now<expiration' , :status => :active, :now => DateTime.now)
    elsif params[:status] == :expired.to_s
      @requests = Request.where('status=:status AND :now>=expiration' , :status => :active, :now => DateTime.now)
    else
      raise "'#{:status}' parameter with value '#{params[:status]}' not recognized."
    end
  end

end
