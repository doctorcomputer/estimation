class HomeController < ApplicationController

  def index
  end

  def how_it_works    
  end

  def personal_index
    if(current_user!=nil)
      @user = current_user
    else
      render :action => :index
    end
  end
  
end
