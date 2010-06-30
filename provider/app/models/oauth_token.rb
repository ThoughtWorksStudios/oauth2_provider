class OauthToken < ActiveRecord::Base

  def generate_access_token!
    update_attribute(:access_token, ActiveSupport::SecureRandom.hex(32))
  end
  
  def access_token_attributes
    {:access_token => access_token}
  end
  
end