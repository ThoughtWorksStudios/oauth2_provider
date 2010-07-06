require 'test_helper'

module OAuth2
  module Provider
    class OAuthTokenTest < ActiveSupport::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
      end
  
      def teardown
        Clock.reset
      end
  
      def test_generate_access_token
        token = OAuthToken.create!
        token.generate_access_token!
        assert_not_nil token.access_token
        assert_nil token.authorization_code
      end
  
      def test_authorization_code_expiry_time_is_1_hour
        token = OAuthToken.create!
        assert_equal 1.hour, token.authorization_code_expires_in
      end
  
      def test_authorization_code_expires_in_1_hour
        token = OAuthToken.create!
        Clock.fake_now = Clock.now + 1.hour
        assert_equal 0, token.authorization_code_expires_in
        assert token.authorization_code_expired?
      end
  
      def test_access_token_expiry_time_is_90_days
        token = OAuthToken.create!
        token.generate_access_token!
        assert_equal 90.days, token.access_token_expires_in
      end
  
      def test_token_expires_in_90_days
        token = OAuthToken.create!
        token.generate_access_token!
        Clock.fake_now = Clock.now + 90.days
        assert_equal 0, token.access_token_expires_in
        assert token.access_token_expired?
      end
  
    end
  end
end