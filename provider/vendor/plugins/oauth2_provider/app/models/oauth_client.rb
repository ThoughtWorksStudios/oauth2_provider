class OauthClient < ActiveRecord::Base

  validates_presence_of :name, :redirect_uri
  before_create :generate_keys
  
  private
  def generate_keys
    self.client_id = random_bytes
    self.client_secret = random_bytes
  end
  
  def random_bytes(size=32)
    Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
  end
  
end
