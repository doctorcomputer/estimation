# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
user1 = User.create(:login => 'albert',
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

user2 = User.create(:login => 'enrico',
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

user3 = User.create(:login => 'louis',
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

request1 = Request.create(:user => user1,
      #active:    request is open to bids
      #expired:   request is close because of expiration date
      #draft:     not already saved
      :status=>:active,
      :title=>'imbiancatura cameretta',
      :description=>'Vorrei imbiancare la cameretta del bambino a prezzi modifici. La camera misura 4 x 4 metri ed è alta 2,80.',
      :expiration=>DateTime.now + 100,
      :condition_confirmation=>DateTime.now)

request2 = Request.create(:user => user3,
      :status=>:active,
      :title=>'baby sitting per il mese di marzo',
      :description=>'Devrò andare fuori città molto spesso nel prossimo mese e sto cercando una baby sitter.',
      :expiration=>DateTime.now + 100,
      :condition_confirmation=>DateTime.now)

Proposal.create(:request => request1,
      :user => user2,
      :description => 'Io posso farlo abbastanza velocemente',
      :amount => '4000 eur',
      :is_best => false)

Proposal.create(:user => user3,
      :request => request1,
      :description => 'Io posso farlo più velocemente',
      :amount => '3000 eur',
      :is_best => true)

