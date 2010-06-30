class OauthClient < ActiveRecord::Base

  validates_presence_of :name
  before_create :generate_keys
  
  private
  def generate_keys
    self.client_id = SecureRandom.random_bytes
    self.client_secret = SecureRandom.random_bytes
  end
    
end
