module Oauth2
  module Provider
    class OauthToken < ::ActiveRecord::Base

      belongs_to :oauth_client, :class_name => "Oauth2::Provider::OauthClient", :foreign_key => 'oauth_client_id'
  
      before_create :update_authorization_code_expiry
  
      DEFAULT_ACCESS_TOKEN_EXPIRY_TIME = 90.days
      DEFAULT_AUTHORIZATION_CODE_EXPIRY_TIME = 1.hour
  
      def generate_access_token!
        update_attributes(
          :access_token => ActiveSupport::SecureRandom.hex(32),
          :access_token_expires_at => Clock.now + DEFAULT_ACCESS_TOKEN_EXPIRY_TIME,
          :refresh_token => ActiveSupport::SecureRandom.hex(32),
          :authorization_code => nil
          )
      end
  
      def access_token_attributes
        {:access_token => access_token, :expires_in => access_token_expires_in, :refresh_token => refresh_token}
      end
  
      def access_token_expires_in
        (Time.at(access_token_expires_at.to_i) - Clock.now).to_i
      end
  
      def access_token_expired?
        access_token_expires_in <= 0
      end

      def authorization_code_expires_in
        (Time.at(authorization_code_expires_at.to_i) - Clock.now).to_i
      end
  
      def authorization_code_expired?
        authorization_code_expires_in <= 0
      end
  
      private
      def update_authorization_code_expiry
        self.authorization_code_expires_at = Clock.now + DEFAULT_AUTHORIZATION_CODE_EXPIRY_TIME
      end
  
    end
  end
end