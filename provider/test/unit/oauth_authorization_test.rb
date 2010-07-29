# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

module Oauth2
  module Provider
    class OauthAuthorizationTest < ActiveSupport::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
        
        client = OauthClient.create!(:name => 'a client', :redirect_uri => 'http://example.com/cb')
        @authorization = client.create_authorization_for_user_id(nil)
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
      
      def test_find_all_by_oauth_client_id
        client1 = OauthClient.create!(:name => "gadget", :redirect_uri => "http://www.example.com/redirect")
        client2 = OauthClient.create!(:name => "bank", :redirect_uri => "http://www.example.com/redirect")
        
        code1 = client1.create_authorization_for_user_id(nil)
        code2 = client1.create_authorization_for_user_id(nil)
        
        assert_equal 2, OauthAuthorization.find_all_by_oauth_client_id(client1.id).size
        assert_equal 0, OauthAuthorization.find_all_by_oauth_client_id(client2.id).size
        
        assert_equal code1.id, OauthAuthorization.find_all_by_oauth_client_id(client1.id).first.id
        assert_equal OauthAuthorization, OauthAuthorization.find_all_by_oauth_client_id(client1.id).first.class
      end
      
      def test_find_by_code
        code1 = OauthAuthorization.create!
        code2 = OauthAuthorization.create!
        
        assert_equal code1.id, OauthAuthorization.find_by_code(code1.code).id
        assert_equal code2.id, OauthAuthorization.find_by_code(code2.code).id
        assert_nil OauthAuthorization.find_by_code("not exists")
      end
  
    end
  end
end