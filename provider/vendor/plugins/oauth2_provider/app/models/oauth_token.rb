class OauthToken < ActiveRecord::Base

  belongs_to :oauth_client
  
  before_create :update_expiry
  
  DEFAULT_EXPIRY_TIME = 1.hour
  
  def generate_access_token!
    update_attributes(
      :access_token => ActiveSupport::SecureRandom.hex(32),
      :expires_at => Clock.now + DEFAULT_EXPIRY_TIME,
      :refresh_token => ActiveSupport::SecureRandom.hex(32),
      :authorization_code => nil
      )
  end
  
  def access_token_attributes
    {:access_token => access_token, :expires_in => expires_in, :refresh_token => refresh_token}
  end
  
  def expires_in
    (Time.at(expires_at.to_i) - Clock.now).to_i
  end
  
  def expired?
    expires_in <= 0
  end
  
  def update_expiry
    self.expires_at = Clock.now + DEFAULT_EXPIRY_TIME
  end
  
end
