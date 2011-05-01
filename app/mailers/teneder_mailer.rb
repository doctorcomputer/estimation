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

  # When an different proposal is chosed by the requestor as the favourite one,
  # a mail is sent to the previous best proposer
  def tender_proposal_discarded_as_best(the_request, the_proposal)
    @request = the_request
    @proposal = the_proposal
    mail(:to => @proposal.user.email,
         :subject => "L'utente #{@request.user.login} ha scelto un'altra offerta come migliore per la sua richiesta numero #{@request.id}"
       )
  end

  # When an offert is chosed by the requestor as the favourite one,
  # a mail is sent to the current offer owner to inform him
  def tender_proposal_choosen_as_best(the_request, the_proposal)
    @request = the_request
    @proposal = the_proposal
    mail(:to => @proposal.user.email,
         :subject => "L'utente #{@request.user.login} ha scelto una tua offerta come migliore per la sua richiesta numero #{@request.id}"
       )
  end

  # When an offer is posted to a request, a mail is sent to the request
  # owner to let him know about it
  def tender_new_proposal_for_request_owner_email(the_request, the_proposal)
    @request = the_request
    @proposal = the_proposal
    mail(:to => @request.user.email,
         :subject => "L'utente #{@proposal.user.login} ha postato una nuova offerta per la tua richiesta numero #{@request.id}"
       )
  end

end
