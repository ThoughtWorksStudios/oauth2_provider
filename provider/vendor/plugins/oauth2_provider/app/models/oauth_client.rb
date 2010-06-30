class OauthClient < ActiveRecord::Base

  validates_presence_of :name
  before_create :generate_keys
  
  private
  def generate_keys
    self.client_id = ActiveSupport::SecureRandom.hex(32)
    self.client_secret = ActiveSupport::SecureRandom.hex(32)
  end
    
end
