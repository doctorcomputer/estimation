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

activities = ['imbiancare', 'ristrutturare', 'demolire', 'trovare qualcuno che possa prendersi cura di']
objects = ['casa mia', 'la cameretta dei bambini', 'Pasqualina, la nonna di 108 anni', 'Gino il mio cagnolino', "l'impianto elettrico"]
ways = ['abbastanza velocemente', 'con calma', 'con qualità sopraffina']
operators = ['Io posso farlo velocemente', "E' la mia specialità lo faccio in tre giorni"]
100.times do |i|

  the_user = users[i % users.length]


  #some drafts
  request1 = Request.create(:user => the_user,
        #active:    request is open to bids
        #expired:   request is close because of expiration date
        #draft:     not already saved
        :status=>:draft,
        :category_id => 'root.house',
        :title=>"#{activities[(i+3) % activities.length]} n. #{i}",
        :description=>"Vorrei #{activities[(i+3) % activities.length]} di #{objects[i % objects.length]} #{ways[(i+2) % ways.length]}.",
        :expiration=>DateTime.now + i,
        :condition_confirmation=>DateTime.now)

  request1 = Request.create(:user => the_user,
        #active:    request is open to bids
        #expired:   request is close because of expiration date
        #draft:     not already saved
        :status=>:active,
        :category_id => 'root.house',
        :title=>"#{activities[(i) % activities.length]} n. #{i}",
        :description=>"Vorrei #{activities[(i) % activities.length]} di #{objects[i % objects.length]} #{ways[(i) % ways.length]}.",
        :expiration=>DateTime.now + i,
        :condition_confirmation=>DateTime.now)

  (i % 11).times do |j|

    offerer = users[ (i+j) % users.length]
    Proposal.create(:request => request1,
          :user => offerer,
          :description => "#{operators[(i) % operators.length]} n. #{j}",
          :amount => "#{(2+i*j)*700} eur",
          :is_best => false)

    offerer = users[ (i+1) % users.length ]
    Proposal.create(:user => offerer,
      :request => request1,
      :description => 'Io posso farlo più velocemente',
      :amount => "#{(i+3)*150} eur",
      :is_best => false)
        
  end


end

20.times do |i|

  request2 = Request.create(:user => user3,
        :status=>:active,
        :category_id => 'root.plants',
        :title=>'baby sitting per il mese di marzo',
        :description=>'Devrò andare fuori città molto spesso nel prossimo mese e sto cercando una baby sitter.',
        :expiration=>DateTime.now + 100,
        :condition_confirmation=>DateTime.now)
      
      
end



