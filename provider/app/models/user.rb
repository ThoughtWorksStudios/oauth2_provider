# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

class User < ActiveRecord::Base
  
  def self.authenticate(email, password)
    User.find_by_email_and_password(email, password)
  end

end
