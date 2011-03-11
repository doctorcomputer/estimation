require 'category'

v = CategoryCollectsAllVisitor.new
Category.root.accept v
categories = v.values

users = Array.new

users.push User.create(:login => 'albert',
  :password => 'albert',
  :password_confirmation => 'albert',
  :email => 'relativity@demo.demo',
  :first_name => 'Albert',
  :last_name => 'Einstein',
  :address => 'Skyline Tower, 7',
  :zip => '12345',
  :city => 'Ulm',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

users.push User.create(:login => 'enrico',
  :password => 'enrico',
  :password_confirmation => 'enrico',
  :email => 'manhattan@demo.demo',
  :first_name => 'Enrico',
  :last_name => 'Fermi',
  :address => 'Bat Cave, 2',
  :zip => '23456',
  :city => 'Roma',
  :is_professional => true,
  :vat => '12345678912',
  :company_name => 'Pitture Atomiche',
  :activity => 'ristrutturazione',
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

users.push User.create(:login => 'louis',
  :password => 'louis',
  :password_confirmation => 'louis',
  :email => 'milk@demo.demo',
  :first_name => 'Louis',
  :last_name => 'Pasteur',
  :address => 'via Eiffel, 7',
  :zip => '13579',
  :city => 'PAris',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

users.push User.create(:login => 'demo1',
  :password => 'demo1',
  :password_confirmation => 'demo1',
  :email => 'demo1@demo.demo',
  :first_name => 'Demolino',
  :last_name => 'Raimondi',
  :address => 'via Dindolo, 17',
  :zip => '13529',
  :city => 'Roma',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

users.push User.create(:login => 'demo2',
  :password => 'demo2',
  :password_confirmation => 'demo2',
  :email => 'demo2@demo.demo',
  :first_name => 'Damiano',
  :last_name => 'Damigiana',
  :address => 'via brocca, 117',
  :zip => '01020',
  :city => 'Tremoli',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

activities = ['imbiancare', 'ristrutturare', 'demolire', 'trovare qualcuno che possa accudire']
objects = ['casa mia', 'la cameretta dei bambini', 'Pasqualina, la nonna di 108 anni', 'Gino il mio cagnolino', "l'impianto elettrico"]
ways = ['abbastanza velocemente', 'con calma', 'con qualità sopraffina']
operators = ['Io posso farlo velocemente', "E' la mia specialità lo faccio in tre giorni", "Non ho idea di come ma ci posso provare"]

number_of_requests = 33

# create some draft requests for the users
number_of_requests.times do |index_request|
  puts "Create draft request #{index_request}/#{number_of_requests}"
  the_user = users[index_request % users.length]

  request1 = Request.create(:user => the_user,
    #active:    request is open to bids
    #expired:   request is close because of expiration date
    #draft:     not already saved
    :status => :draft,
    :category_id => categories[rand(categories.length)],
    :title=>"#{activities[(index_request+3) % activities.length]} n. #{index_request}",
    :description=>"Vorrei #{activities[(index_request+3) % activities.length]} di #{objects[index_request % objects.length]} #{ways[(index_request+2) % ways.length]}.",
    :expiration=>DateTime.now + index_request,
    :condition_confirmation=>DateTime.now)

end



# create some active Request for the user with a best offer
number_of_requests.times do |index_request|
  puts "Create active request #{index_request}/#{number_of_requests}"

  the_user = users[index_request % users.length]

  # create an active Request for the user
  request1 = Request.create(:user => the_user,
    #active:    request is open to bids
    #expired:   request is close because of expiration date
    #draft:     not already saved
    :status=>:active,
    :category_id => categories[rand(categories.length)],
    :title=>"#{activities[(index_request) % activities.length]} n. #{index_request}",
    :description=>"Vorrei #{activities[(index_request) % activities.length]} di #{objects[index_request % objects.length]} #{ways[(index_request) % ways.length]}.",
    :expiration=>DateTime.now + index_request,
    :condition_confirmation=>DateTime.now)


  number_of_proposals = index_request % 3
  (number_of_proposals).times do |j|

    last_proposal = users[ (index_request+j) % users.length]
    Proposal.create(:request => request1,
      :user => last_proposal,
      :description => "#{operators[(index_request) % operators.length]} n. #{j}",
      :amount => "#{(2+index_request*j)*700} eur",
      :is_best => false)

    last_proposal = users[ (index_request+1) % users.length ]
    Proposal.create(:user => last_proposal,
      :request => request1,
      :description => 'Io posso farlo più velocemente',
      :amount => "#{(index_request+3)*150} eur",
      :is_best => (number_of_proposals-3 == j))

  end

end

# create some active Request for the user with a best offer
number_of_requests.times do |index_request|
  puts "Create expired request #{index_request}/#{number_of_requests}"

  the_user = users[index_request % users.length]

  # create an active Request for the user
  request1 = Request.new(:user => the_user,
    #active:    request is open to bids
    #expired:   request is close because of expiration date
    #draft:     not already saved
    :status=>:active,
    :category_id => categories[rand(categories.length)],
    :title=>"#{activities[(index_request) % activities.length]} n. #{index_request}",
    :description=>"Vorrei #{activities[(index_request) % activities.length]} di #{objects[index_request % objects.length]} #{ways[(index_request) % ways.length]}.",
    :expiration=>DateTime.now - index_request,
    :condition_confirmation=>DateTime.now)
  request1.save(:validate => false)

  number_of_proposals = index_request % 3
  number_of_proposals.times do |j|


      operator_user = users[ (index_request+j) % users.length]
      Proposal.create(
        :user => operator_user,
        :request => request1,
        :description => "#{operators[(index_request) % operators.length]} n. #{j}",
        :amount => "#{(2+index_request*j)*700} eur",
        :is_best => false)

      operator_user = users[ (index_request+1) % users.length ]
      Proposal.create(
        :user => operator_user,
        :request => request1,
        :description => 'Io posso farlo più velocemente',
        :amount => "#{(index_request+3)*150} eur",
        :is_best => (number_of_proposals-2 == j))

  end
end