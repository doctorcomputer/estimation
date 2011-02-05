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
    begin
      unless params[:expiration_date].nil?
        @request.expiration= Date.strptime(params[:expiration_date], "%d/%m/%Y")
      end
    rescue
      @request.expiration= nil
    end
    @request.status = :draft

    if @request.save
      flash[:notice]= "La tua richiesta è stata memorizzata. Ricordati di attivarla."
      redirect_to :controller => :home,  :action => :personal_index
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
  end

  def index
    @requests = Request.where(:status => :draft)
  end

end
