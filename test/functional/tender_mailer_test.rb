require 'test_helper'

class TenderMailerTest < ActionMailer::TestCase

  def test_tender_new_proposal_for_request_owner_email
    request = requests(:request_one)
    proposal = proposals(:proposal_one)

    email = TenderMailer.tender_new_proposal_for_request_owner_email(request, proposal).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # mail is sent to request owner
    assert_equal request.user.email, email.to[0]

    # the subject contains the request id
    assert_match /#{request.id}/, email.subject
    assert_match /#{proposal.user.login}/, email.subject

    # body contains the proposal author login
    assert_match /#{proposal.user.login}/, email.encoded

    # body contains the request owner name
    assert_match /#{request.user.first_name}/, email.encoded
    assert_match /#{request.user.last_name}/, email.encoded
  end

end
