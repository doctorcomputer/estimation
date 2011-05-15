class RegistrationMailer < ActionMailer::Base

  default :from => "noreply@miserve.eu"

  def registration_activation_email(user)
    @user = user
    mail(:to => user.email,
         :subject => "Per favore conferma l'iscrizione")
  end

  def registration_verification_email(user)
    @user = user
    mail(:to => user.email,
         :subject => "Registrazione confermata")
  end

end
