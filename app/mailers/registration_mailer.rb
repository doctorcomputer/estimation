class RegistrationMailer < ActionMailer::Base

  default :from => "info@mi-serve.com"

  def registration_activation_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email,
         :subject => "Per favore conferma l'iscrizione")
  end

  def registration_verification_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email,
         :subject => "Registrazione confermata")
  end

end
