# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

module Oauth2
  module Provider
    class OauthClientTest < ActiveSupport::TestCase
      def test_should_generate_client_id_and_client_secret_when_creating_clients
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert_not_nil client.client_id
        assert_not_nil client.client_secret
      end
  
      def test_should_not_allow_creating_clients_without_a_name
        client = OauthClient.create(:redirect_uri => 'http://example.com/cb')
        assert_equal ["Name can't be empty"], client.errors.full_messages
      end
  
      def test_should_not_allow_creating_clients_without_a_redirct_uri
        client = OauthClient.create(:name => 'foobar')
        assert_equal ["Redirect uri can't be empty", "Redirect uri is invalid"], client.errors.full_messages
      end
      
      def test_should_not_allow_invalid_redirect_uri
        assert !OauthClient.new(:name=>'foo', :redirect_uri => 'some-uri').save
        
        client = OauthClient.create(:name=>'foo', :redirect_uri => 'http://foo.com/cb')
        client.redirect_uri = 'some-uri'
        assert !client.save
      end
      
      def test_can_create_token_for_user
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        
        token = client.create_token_for_user_id("337")
        assert_equal client.id, token.oauth_client.id
        assert_equal "337", token.user_id
        assert_equal 64, token.access_token.length
      end
      
      def test_can_create_authorization_for_user
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        authorization = client.create_authorization_for_user_id("229")
        assert_equal client.id, authorization.oauth_client.id
        assert_equal "229", authorization.user_id
        assert_equal 64, authorization.code.length
      end
      
      def test_destroys_tokens_belong_to_it_on_delete
        client1 = OauthClient.create!(:name=>'name1', :redirect_uri=>'http://example1.com/cb')
        client1_token = client1.create_token_for_user_id(nil)
        client2 = OauthClient.create!(:name=>'name2', :redirect_uri=>'http://example2.com/cb')
        client2_token = client2.create_token_for_user_id(nil)

        client1.destroy
        assert_nil OauthToken.find_by_id(client1_token.id)
        assert_not_nil OauthToken.find(client2_token.id)
      end
      
      
      def test_destroys_authorization_code_belong_to_it_on_delete
        client1 = OauthClient.create!(:name=>'name1', :redirect_uri=>'http://example1.com/cb')
        client1_code = client1.create_authorization_for_user_id(nil)
        client2 = OauthClient.create!(:name=>'name2', :redirect_uri=>'http://example2.com/cb')
        client2_code = client2.create_authorization_for_user_id(nil)

        client1.destroy
        assert_nil OauthAuthorization.find_by_id(client1_code.id)
        assert_not_nil OauthAuthorization.find_by_id(client2_code.id)
      end
      
    end
  end
end