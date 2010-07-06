module OAuth2
  module Provider
    class OAuthClient < ActiveRecord::Base

      validates_presence_of :name, :redirect_uri
      before_create :generate_keys
      has_many :o_auth_tokens, :class_name => "OAuth2::Provider::OAuthToken"

      private
      def generate_keys
        self.client_id = ActiveSupport::SecureRandom.hex(32)
        self.client_secret = ActiveSupport::SecureRandom.hex(32)
      end
    
    end
  end
end