# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../../../test_helper')

module Oauth2
  module Provider
    class OauthClientsControllerApiTest < ActionController::TestCase
      def setup
        @user = User.create!(:email => 'foo@bar.com', :password => 'top-secret')
        session[:user_id] = @user.id
        @controller = OauthClientsController.new
      end
      
      def test_index_shows_all_clients
        client1 = OauthClient.create!(:name => 'name1', :redirect_uri => 'http://example1.com')
        client2 = OauthClient.create!(:name => 'name2', :redirect_uri => 'http://example2.com')
    
        get :index, :format => 'xml'
        
        assert_select "oauth_clients" do
          assert_select "oauth_client name", :text => 'name1'
          assert_select "oauth_client redirect_uri", :text => 'http://example1.com'
          assert_select "oauth_client client_id", :text => client1.client_id
          assert_select "oauth_client client_secret", :text => client1.client_secret

          assert_select "oauth_client name", :text => 'name2'
          assert_select "oauth_client redirect_uri", :text => 'http://example2.com'
          assert_select "oauth_client client_id", :text => client2.client_id
          assert_select "oauth_client client_secret", :text => client2.client_secret
        end
      end
      
      def test_create_creates_new_oauth_client
        post :create, :oauth_client => {:name => 'my application', :redirect_uri => 'http://api.example.com/cb'}, :format => 'xml'
        assert_equal 1, OauthClient.all.size
        assert !OauthClient.all.first.client_id.blank?
        assert !OauthClient.all.first.client_secret.blank?
        assert_equal 'my application', OauthClient.all.first.name
        assert_equal 'http://api.example.com/cb', OauthClient.all.first.redirect_uri
        assert_response :created
        
        assert_equal oauth_client_url(OauthClient.all.first), @response.header['Location']
        
      end
      
      def test_should_not_create_oauth_client_without_name_or_redirect_uri
        post :create, :oauth_client => {:name => 'my application'}, :format => 'xml'
        assert_equal 0, OauthClient.count
        post :create, :oauth_client => {:redirect_uri => 'http://api.example.com/cb'}, :format => 'xml'
        assert_equal 0, OauthClient.count
      end
      
      def test_update_writes_new_attributes
        client = OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
        post :update, :id => client.id, :oauth_client => {:name => 'new name', :redirect_uri => 'http://new.example.com/cb'}, :format => 'xml'
        client.reload
        assert_equal 'new name', client.name
        assert_equal 'http://new.example.com/cb', client.redirect_uri
        assert_response :ok
      end
      
      def test_can_show_an_oauth_client
        client = OauthClient.create!(:name => 'name1', :redirect_uri => 'http://example1.com')
        
        get :show, :id => client.id, :format => 'xml'
        
        assert_select "oauth_client" do
          assert_select "oauth_client name", :text => client.name
          assert_select "oauth_client redirect_uri", :text => client.redirect_uri
          assert_select "oauth_client client_id", :text => client.client_id
          assert_select "oauth_client client_secret", :text => client.client_secret
        end
      end
      
      def test_can_destroy_an_oauth_client
        client = OauthClient.create!(:name => 'name1', :redirect_uri => 'http://example1.com')
        assert_equal 1, OauthClient.count
        delete :destroy, :id => client.id, :format => 'xml'
        assert_response :ok
        assert_equal 0, OauthClient.count
      end
      
    end
  end
end