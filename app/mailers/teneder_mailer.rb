# This mailer generate all mails used during the tender period.
#
# Author::    Daniele Demichelis  (demichelis at danidemi dot com)
# Copyright:: Copyright (c) 2011 Studio Ingegneria Demichelis
class TenderMailer < ActionMailer::Base

  # Users can define the categories they are most interested in.
  # When a new request is posted, if the request matches with
  # the user's preferencies, a mail is sent to him.
#  def tender_new_interesting_request(interesting_request, recipient_user)
#    @user = user
#    mail(:to => user.email,
#         :subject => "Per favore conferma l'iscrizione")
#  end

  # When an offert is posted to a request, a mail is sent to the request
  # owner to let him know about it
  def tender_new_proposal_for_request_owner_email(the_request, the_proposal)
    @request = the_request
    @proposal = the_proposal
    mail(:to => @request.user.email,
         :subject => "L'utente #{@proposal.user.login} ha postato una nuova offerta per la tua richiesta numero #{@request.id}"
       )
  end

end
