module OAuth2
  module Provider
    class OAuthClient < ActiveRecord::Base

      validates_presence_of :name, :redirect_uri
      before_create :generate_keys
      has_many :oauth_tokens, :class_name => "OAuth2::Provider::OAuthToken", :dependent => :delete_all

      def self.model_name
        ActiveSupport::ModelName.new('OAuthClient')
      end

      private
      def generate_keys
        self.client_id = ActiveSupport::SecureRandom.hex(32)
        self.client_secret = ActiveSupport::SecureRandom.hex(32)
      end
    
    end
  end
end