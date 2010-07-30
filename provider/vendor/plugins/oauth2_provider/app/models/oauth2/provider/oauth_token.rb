# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    class OauthToken < ModelBase

      columns :user_id, :oauth_client_id, :access_token, :refresh_token, :expires_at

      EXPIRY_TIME = 90.days

      def self.find_all_by_oauth_client_id(client_id)
        find_collection(:find_all_oauth_tokens_by_client_id, client_id)
      end

      def self.find_all_by_user_id(user_id)
        find_collection(:find_all_oauth_tokens_by_user_id, user_id)
      end

      def self.find_by_access_token(access_token)
        find_one(:find_oauth_token_by_access_token, access_token)
      end

      def self.find_by_refresh_token(refresh_token)
        find_one(:find_oauth_token_by_refresh_token, refresh_token)
      end

      def oauth_client
        OauthClient.find_by_id(oauth_client_id)
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

      def refresh
        self.destroy
        oauth_client.create_token_for_user_id(user_id)
      end

      def before_create
        self.access_token = ActiveSupport::SecureRandom.hex(32)
        self.expires_at = (Clock.now + EXPIRY_TIME).to_i
        self.refresh_token = ActiveSupport::SecureRandom.hex(32)
      end

    end
  end
end