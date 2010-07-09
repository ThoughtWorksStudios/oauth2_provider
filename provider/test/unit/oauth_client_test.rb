require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

module Oauth2
  module Provider
    class OauthClientTest < ActiveSupport::TestCase
      def should_generate_client_id_and_client_secret_when_creating_clients
        client = OauthClient.create!(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert_not_nil client.client_id
        assert_not_nil client.client_secret
      end
  
      def should_not_allow_creating_clients_without_a_name
        assert_raise_with_message ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank" do
          OauthClient.create!(:redirect_uri => 'http://example.com/cb')
        end
      end
  
      def should_not_allow_creating_clients_without_a_redirct_uri
        assert_raise_with_message ActiveRecord::RecordInvalid, "Validation failed: Redirect uri can't be blank" do
          OauthClient.create!(:name => 'foobar')
        end
      end
      
      def test_should_not_allow_invalid_redirect_uri
        assert !OauthClient.create(:name=>'foo', :redirect_uri => 'some-uri').save
        
        client = OauthClient.create!(:name=>'foo', :redirect_uri => 'http://foo.com/cb')
        client.redirect_uri = 'some-uri'
        assert !client.save
      end
      
      def test_can_create_token_for_user
        client = OauthClient.create!(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        
        token = client.create_token_for_user_id("337")
        token.reload
        assert_equal client, token.oauth_client
        assert_equal "337", token.user_id
        assert_equal 64, token.authorization_code.length
        assert_nil token.access_token 
      end
      
    end
  end
end