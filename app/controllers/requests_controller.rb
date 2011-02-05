class RequestsController < ApplicationController

  def new
    @request = Request.new
  end

  def create

    @request = User.new(params[:request])

    if @user.save
      flash.now[:notice]= "La tua richiesta è stata memorizzata. Ricordati di attivarla."
      render :template => 'home/personal_index'
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
  end

end
