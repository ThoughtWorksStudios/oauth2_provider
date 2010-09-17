# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create!(:email => 'admin', :password => 'p')
User.create!(:email => 'mingledev01@thoughtworks.com', :password => 'p')
User.create!(:email => 'mingledev02@thoughtworks.com', :password => 'p')
User.create!(:email => 'admin@thoughtworks.com', :password => 'p')
