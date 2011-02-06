# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
User.create(:login => 'demo1',
  :password => 'demo1',
  :password_confirmation => 'demo1',
  :email => 'demo1@demo.demo',
  :first_name => 'demo',
  :last_name => 'demo',
  :address => 'Main street',
  :zip => '12345',
  :city => 'Metropolis',
  :is_professional => false,
  :login_count => 1,
  :last_eula_confirmation => DateTime.now,
  :last_privacy_confirmation => DateTime.now,
  :confirmed => true)
