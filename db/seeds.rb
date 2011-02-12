# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
user1 = User.create(:login => 'demo1',
  :password => 'demo1',
  :password_confirmation => 'demo1',
  :email => 'demo1@demo.demo',
  :first_name => 'Danile',
  :last_name => 'De Mo',
  :address => 'Place Demo, 7',
  :zip => '12345',
  :city => 'Metropolis',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

user2 = User.create(:login => 'demo2',
  :password => 'demo2',
  :password_confirmation => 'demo2',
  :email => 'demo2@demo.demo',
  :first_name => 'Demis',
  :last_name => 'Demo',
  :address => 'Demo street, 2',
  :zip => '12345',
  :city => 'Gotham City',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)

#user2 = User.create(:login => 'demo2',
#  :password => 'demo2',
#  :password_confirmation => 'demo2',
#  :email => 'demo2@demo.demo',
#  :first_name => 'Demis',
#  :last_name => 'Demo',
#  :address => 'Demo street, 2',
#  :zip => '12345',
#  :city => 'Gotham City',
#  :is_professional => true,
#  :vat => 'IT123456789',
#  :company_name => 'Paint & Pints',
#  :activity => 'restructuring',
#  :login_count => 1,
#  :last_eula_confirmation => DateTime.now,
#  :last_privacy_confirmation => DateTime.now,
#  :confirmed => true)

request1 = Request.create(:user => user1,
      #active:    request is open to bids
      #expired:   request is close because of expiration date
      #draft:     not already saved
      :status=>:active,
      :title=>'cameretta',
      :description=>'vorrei pitturare la cameretta del bambino a prezzi modifici',
      :expiration=>DateTime.now + 100,
      :condition_confirmation=>DateTime.now)

Proposal.create(
      :user_id => user1.id,
      :request_id => request1.id,
      :description => 'Io posso farlo abbastanza velocemente',
      :amount => '4000 eur',
      :is_best => false)

Proposal.create(
      :user_id => user2.id,
      :request_id => request1.id,
      :description => 'Io posso farlo più velocemente',
      :amount => '3000 eur',
      :is_best => true)

