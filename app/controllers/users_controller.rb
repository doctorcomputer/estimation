class UsersController < ApplicationController

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @user.is_professional = false
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create

    @user = User.new(params[:user])

    if( params[:email_confirmation].nil? || params[:email_confirmation] != params[:user][:email])
      flash.now[:error]= "La mail di conferma non corrisponde."
      render :action => :new
      return
    end

    if params[:user][:eula]=="1"
      @user.last_eula_confirmation = DateTime.now
    end
    if params[:user][:privacy]=="1"
      @user.last_privacy_confirmation = DateTime.now
    end

    if @user.save
      RegistrationMailer.registration_verification_email(@user).deliver
      flash[:notice]= "Riceverai una mail di attivazione."
      redirect_to "/"
    else
      flash.now[:error]= "Si sono verificati degli errori."
      render :action => :new
    end
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
