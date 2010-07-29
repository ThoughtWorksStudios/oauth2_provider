# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    class OauthClient < ModelBase
      
      validates_presence_of :name, :redirect_uri
      validates_format_of :redirect_uri, :with => Regexp.new("^(https|http)://.+$")
      
      columns :name, :client_id, :client_secret, :redirect_uri

      def create_token_for_user_id(user_id)
        OauthToken.create!(:user_id => user_id, :oauth_client_id => id)
      end
      
      def create_authorization_for_user_id(user_id)
        OauthAuthorization.create!(:user_id => user_id, :oauth_client_id => id)
      end
      
      def self.find_by_client_id(client_id)
        find_one(:find_oauth_client_by_client_id, client_id)
      end
      
      def self.model_name
        ActiveSupport::ModelName.new('OauthClient')
      end

      def oauth_tokens
        OauthToken.find_all_by_oauth_client_id(id)
      end
      
      def oauth_authorizations
        OauthAuthorization.find_all_by_oauth_client_id(id)
      end
      
      def before_create
        self.client_id = ActiveSupport::SecureRandom.hex(32)
        self.client_secret = ActiveSupport::SecureRandom.hex(32)
      end
      
      def before_destroy
        oauth_tokens.each(&:destroy)
        oauth_authorizations.each(&:destroy)
      end
    
    end
  end
end