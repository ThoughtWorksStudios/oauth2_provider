require File.join(File.dirname(__FILE__), '../test_helper')

module Oauth2
  module Provider
    class OauthAuthorizationTest < ActiveSupport::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
        
        client = OauthClient.create!(:name => 'a client', :redirect_uri => 'http://example.com/cb')
        @authorization = client.oauth_authorizations.create!
      end
  
      def teardown
        Clock.reset
      end
      
      def test_generates_access_code_on_create
        assert_not_nil @authorization.code
      end
  
      def test_generate_access_token
        token = @authorization.generate_access_token
        assert_not_nil token.access_token
        assert_nil OauthAuthorization.find_by_id(@authorization.id)
      end
  
      def test_authorization_code_expiry_time_is_1_hour
        assert_equal 1.hour, @authorization.expires_in
      end
  
      def test_authorization_code_expires_in_1_hour
        Clock.fake_now = Clock.now + 1.hour
        assert_equal 0, @authorization.expires_in
        assert @authorization.expired?
      end
  
    end
  end
end