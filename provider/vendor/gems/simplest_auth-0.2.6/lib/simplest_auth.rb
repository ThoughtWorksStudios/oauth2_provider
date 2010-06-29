begin
  require 'bcrypt'
rescue LoadError
  begin
    gem 'bcrypt-ruby'
  rescue Gem::LoadError
    puts "Please install the bcrypt-ruby gem"
  end
end

# SimplestAuth
require 'simplest_auth/model'
require 'simplest_auth/controller'