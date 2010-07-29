# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

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
      
      def test_refresh_deletes_self_and_issues_new_token_for_same_user_and_client
        client = OauthClient.create!(:name => "gadget", :redirect_uri => "http://www.example.com/redirect")
        original_token = client.create_token_for_user_id("3")
        new_token = original_token.refresh
        assert_nil OauthToken.find_by_id(original_token.id)
        assert_not_nil OauthToken.find_by_id(new_token.id)
        assert_not_nil new_token.access_token
        assert_not_nil new_token.refresh_token
        assert_not_equal new_token.access_token, original_token.access_token
        assert_not_equal new_token.refresh_token, original_token.refresh_token
        assert_equal client.id, new_token.oauth_client.id
        assert_equal "3", new_token.user_id
        assert_equal 90.days, new_token.expires_in
      end
      
      def test_find_all_by_oauth_client_id
        client1 = OauthClient.create!(:name => "gadget", :redirect_uri => "http://www.example.com/redirect")
        client2 = OauthClient.create!(:name => "bank", :redirect_uri => "http://www.example.com/redirect")
        
        token1 = client1.create_token_for_user_id(nil)
        token2 = client1.create_token_for_user_id(nil)
        
        assert_equal 2, OauthToken.find_all_by_oauth_client_id(client1.id).size
        assert_equal 0, OauthToken.find_all_by_oauth_client_id(client2.id).size
        
        assert_equal token1.id, OauthToken.find_all_by_oauth_client_id(client1.id).first.id
        assert_equal OauthToken, OauthToken.find_all_by_oauth_client_id(client1.id).first.class
      end
      
      def test_find_by_access_token
        token1 = OauthToken.create!
        token2 = OauthToken.create!
        
        assert token1.id, OauthToken.find_by_access_token(token1.access_token).id
        assert token2.id, OauthToken.find_by_access_token(token2.access_token).id
        assert_nil OauthToken.find_by_access_token('not exist')
      end
      
      def test_find_by_refresh_token
        token1 = OauthToken.create!
        token2 = OauthToken.create!
        
        assert token1.id, OauthToken.find_by_refresh_token(token1.refresh_token).id
        assert token2.id, OauthToken.find_by_refresh_token(token2.refresh_token).id
        assert_nil OauthToken.find_by_refresh_token('not exist')
      end
      
      def test_find_all_by_user_id
        token1 = OauthToken.create!(:user_id => '42')
        token2 = OauthToken.create!(:user_id => '13')
        token3 = OauthToken.create!(:user_id => '13')
        
        assert_equal 2, OauthToken.find_all_by_user_id(13).size
        assert_equal token2.id, OauthToken.find_all_by_user_id(13).first.id
        assert_equal token3.id, OauthToken.find_all_by_user_id(13).last.id
      end
    end
  end
end