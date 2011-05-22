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

  # Invoked when a user lost his/her password
  def lost_password

  end

  # Invoked when a user lost his/her password
  def require_reset_password_token
    email = params[:email]
    if email.nil? || email.blank?
      flash.now[:error] = "Per favore, fornisci un indirizzo di posta elettronica."
      render :action => :lost_password
      return
    end

    user = User.find_by_email email
    if !user.nil?
      new_token = user.reset_perishable_token!
      flash.now[:notice] = "E' stata inviata una mail all'indirizzo #{user.email} con le istruzioni per il reset della password."
      RegistrationMailer.reset_password_email(user, new_token).deliver
      render :template => "users/generic.html.erb"
    else
      flash.now[:warning] = "L'indirizzo di posta elettronica '#{email}' non risulta associato ad alcun utente."
      render :action => :lost_password
    end
  end

  def confirm_password_reset
    @token = params[:activation_token]

    if @token.nil? || @token.strip.length == 0
      flash.now[:error] = "Il token non è valido."
      render :template => "users/generic.html.erb"
      return
    end

    user = User.find_by_perishable_token @token
    if user.nil?
      flash.now[:error] = "Il token non esiste."
      render :template => "users/generic.html.erb"
      return
    end

    render :action => :password_reset
    return
  end

  def password_reset
    puts '*********** 0'
    @token = params[:activation_token]

    if @token.nil? || @token.strip.length == 0
      flash.now[:error] = "Il token non è valido."
      render :template => "users/generic.html.erb"
      return
    end

    user = User.find_by_perishable_token @token
    if user.nil?
      flash.now[:error] = "Il token non esiste."
      render :template => "users/generic.html.erb"
      return
    end

    new_password = params[:password]
    password_confirmation = params[:password_confirmation]

    puts "zappala: #{new_password} / #{password_confirmation}"

    if !new_password.nil? && new_password==password_confirmation
      user.password = new_password
      user.password_confirmation = password_confirmation
      if user.save
        flash.now[:notice] = "La password è stata cambiata."
        render :template => "users/generic.html.erb"
        return
      end
    else
      flash.now[:error] = "La password non corrisponde."
      render :action => :password_reset
      return
    end
  end

end
