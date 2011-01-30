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
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      #render :action => 'new'
      flash[:error] = "Unable to login"
      redirect_to root_url
    end
  end

  # Called to destroy a session, that means a logout.
  # DELETE /uses_sessions/1
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
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


#    if user
#      flash[:notice] = "L'account è stato correttamente attivato. Puoi ora loggarti con i tuoi username e password."
#    else
#      flash[:error] = "Nessun account corrisponde al token di attivazione fornito."
#    end
  end




  #  # GET /users
  #  # GET /users.xml
  #  def index
  #    @users = User.all
  #
  #    respond_to do |format|
  #      format.html # index.html.erb
  #      format.xml  { render :xml => @users }
  #    end
  #  end
  #
  #  # GET /users/1
  #  # GET /users/1.xml
  #  def show
  #    @user = User.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.xml  { render :xml => @user }
  #    end
  #  end
  #
  #  # GET /users/1/edit
  #  def edit
  #    @user = User.find(params[:id])
  #  end
  #
  #  # PUT /users/1
  #  # PUT /users/1.xml
  #  def update
  #    @user = User.find(params[:id])
  #
  #    respond_to do |format|
  #      if @user.update_attributes(params[:user])
  #        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
  #        format.xml  { head :ok }
  #      else
  #        format.html { render :action => "edit" }
  #        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  end
  #
  #  # DELETE /users/1
  #  # DELETE /users/1.xml
  #  def destroy
  #    @user = User.find(params[:id])
  #    @user.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(users_url) }
  #      format.xml  { head :ok }
  #    end
  #  end
end

