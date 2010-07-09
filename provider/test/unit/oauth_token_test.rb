require 'test_helper'

module Oauth2
  module Provider
    class OauthTokenTest < ActiveSupport::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
      end
  
      def teardown
        Clock.reset
      end
  
      def test_access_token_is_generated_on_create
        token = OauthToken.create!
        assert_not_nil token.access_token
      end
  
      def test_expiry_time_is_90_days
        token = OauthToken.create!
        assert_equal 90.days, token.expires_in
      end
  
      def test_expires_in_90_days
        token = OauthToken.create!
        Clock.fake_now = Clock.now + 90.days
        assert_equal 0, token.expires_in
        assert token.expired?
      end
  
    end
  end
end