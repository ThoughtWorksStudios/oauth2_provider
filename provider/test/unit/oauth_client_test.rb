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
      
      def test_after_create_can_find_it_back_through_id
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert_equal OauthClient, OauthClient.find(client.id).class
        
        assert_equal client.id, OauthClient.find(client.id).id
        assert_equal client.name, OauthClient.find(client.id).name

        assert_equal client.client_id, OauthClient.find(client.id).client_id
        assert_equal client.client_secret, OauthClient.find(client.id).client_secret

        assert_equal client.redirect_uri, OauthClient.find(client.id).redirect_uri
      end
      
      def test_update_attributes
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        client.update_attributes(:name => 'barfoo', :redirect_uri => 'http://example.net/bc')
        assert_equal 'barfoo', client.name
        assert_equal 'http://example.net/bc', client.redirect_uri
        
        client_from_db = OauthClient.find(client.id)
        assert_equal 'barfoo', client_from_db.name
        assert_equal 'http://example.net/bc', client_from_db.redirect_uri
      end
      
      def test_find_throws_error_if_there_is_no_client_with_id
        assert_raise_with_message(NotFoundException, "Record not found!") { OauthClient.find('not_exist') }
      end

      def test_should_save_if_model_is_valid
        client = OauthClient.new(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert client.save
      end
            
      def test_should_not_save_if_model_is_invalid
        client = OauthClient.new(:name => 'foobar')
        assert !client.save
      end
      
      def test_create_bang_should_raise_exception_when_model_is_invalid
        assert_not_nil OauthClient.create!(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert_raise_with_message(RecordNotSaved, "Could not save model!") { OauthClient.create!(:name => 'foobar') } 
      end
      
      def test_find_all
        client1 = OauthClient.create(:name => 'foobar1', :redirect_uri => 'http://example.com/cb')
        client2= OauthClient.create(:name => 'foobar2', :redirect_uri => 'http://example.com/cb')
        
        assert_equal [client1.id, client2.id], OauthClient.all.collect(&:id)
      end
      
      def test_count
        assert_equal 0, OauthClient.count
        OauthClient.create(:name => 'foobar1', :redirect_uri => 'http://example.com/cb')
        assert_equal 1, OauthClient.count
        OauthClient.create(:name => 'foobar2', :redirect_uri => 'http://example.com/cb')
        assert_equal 2, OauthClient.count
      end
      
      def test_reload
        client = OauthClient.create(:name => 'foobar2', :redirect_uri => 'http://example.com/cb')
        client.name = 'haha'
        client.reload
        client.name = 'foobar2'
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
      
      def test_destroy
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        client.destroy
        assert_raise(NotFoundException) { OauthClient.find(client.id) }
      end
      
      def test_find_by_id
        client = OauthClient.create(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
        assert_equal client.id, OauthClient.find_by_id(client.id).id
        assert_nil OauthClient.find_by_id("not exist")
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
      
      
      def test_find_by_client_id
        client1 = OauthClient.create!(:name=>'name1', :redirect_uri=>'http://example1.com/cb')
        client2 = OauthClient.create!(:name=>'name2', :redirect_uri=>'http://example2.com/cb')
        assert_equal OauthClient, OauthClient.find_by_client_id(client1.client_id).class
        assert_equal client1.id, OauthClient.find_by_client_id(client1.client_id).id
        assert_equal client2.id, OauthClient.find_by_client_id(client2.client_id).id
        assert_nil OauthClient.find_by_client_id("not exist")
      end
      
      
    end
  end
end