class UserSessionsController < ApplicationController

  # Called for a new user session, that means a login form.
  # GET /user_sessions/new
  def new
    @user_session = UserSession.new
  end

  # Called for a new user session, that means a login.
  # POST /user_sessions
  def create
    @user_session = UserSession.new(params[:user_session])
    
    if @user_session.save
      flash[:notice] = "Bentornato #{@user_session.record.first_name}!"
      if visited_request!=nil
        redirect_to request_detail_path(visited_request)
      else
        redirect_to root_url
      end
    else
      #render :action => 'new'
      flash[:error] = "Dati di login errati."
      redirect_to root_url
    end
  end

  # Called to destroy a session, that means a logout.
  # DELETE /uses_sessions/1
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    set_visited_request nil
    flash[:notice] = "Sei uscito dal tuo account personale."
    redirect_to root_url
  end

  def show
    redirect_to root_url
  end

  # Call the view used to activate a new account
  def activation

  end

  # Actually tries to activate the account with the provided token
  def activate
    token = params[:activation_token]

    if token.nil? || token.strip.length == 0
      flash.now[:error] = "Il token non è valido."
      render :action => :activation
      return
    end

    user = User.find_by_perishable_token token
    if user.nil?
      flash.now[:error] = "Il token non esiste."
      render :action => :activation
      return
    end

    user.confirmed=true
    if user.save
      RegistrationMailer.registration_activation_email(user).deliver
      flash[:notice] = "L'account è stato correttamente attivato."
      redirect_to root_path
    else
      flash.now[:error] = "Si sono verificati dei problemi durante l'attivazione dell'account."
      render :action => :activation
    end

  end

end

