class User < ActiveRecord::Base
  
  def self.authenticate(email, password)
    User.find_by_email_and_password(email, password)
  end

end
