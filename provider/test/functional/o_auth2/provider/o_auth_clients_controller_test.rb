require 'test_helper'

module Oauth2
  module Provider
    class OauthClientsControllerTest < ActionController::TestCase

      def setup
        @user = User.create!(:email => 'foo@bar.com', :password => 'top-secret')
        session[:user_id] = @user.id
      end
      
      def test_index_shows_all_clients
        client1 = OauthClient.create!(:name => 'name1', :redirect_uri => 'http://example1.com')
        client2 = OauthClient.create!(:name => 'name2', :redirect_uri => 'http://example2.com')
    
        get :index
        
        assert_select "table" do
          assert_select "td", :text => 'name1'
          assert_select "td", :text => 'http://example1.com'
          assert_select "td", :text => client1.client_id
          assert_select "td", :text => client1.client_secret
          
          assert_select "td", :text => 'name2'
          assert_select "td", :text => 'http://example2.com'
          assert_select "td", :text => client2.client_id
          assert_select "td", :text => client2.client_secret
        end
      end
      
      def test_create_creates_new_oauth_client
        post :create, :oauth_client => {:name => 'my application', :redirect_uri => 'http://api.example.com/cb'}
        assert_not_nil OauthClient.find_by_name_and_redirect_uri('my application', 'http://api.example.com/cb')
      end

      def test_should_not_create_oauth_client_without_name_or_redirect_uri
        post :create, :oauth_client => {:name => 'my application'}
        assert_equal 0, OauthClient.count
        post :create, :oauth_client => {:redirect_uri => 'http://api.example.com/cb'}
        assert_equal 0, OauthClient.count
      end
      
      def test_can_destroy_an_oauth_client
        client1 = OauthClient.create!(:name=>'name1', :redirect_uri=>'http://example1.com/cb')
        client1_token = client1.oauth_tokens.create!
        client2 = OauthClient.create!(:name=>'name2', :redirect_uri=>'http://example2.com/cb')
        client2_token = client2.oauth_tokens.create!

        post :destroy, :id => client1.id
        assert_nil OauthClient.find_by_name_and_redirect_uri('name1', 'http://example1.com/cb')
        assert_nil OauthToken.find_by_id(client1_token.id)
        assert_not_nil OauthClient.find_by_name_and_redirect_uri('name2', 'http://example2.com/cb')
        assert_not_nil OauthToken.find(client2_token.id)
      end
      
      def test_update_writes_new_attributes
        client = OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
        post :update, :id => client.id, :oauth_client => {:name => 'new name', :redirect_uri => 'http://new.example.com/cb'}
        client.reload
        assert_equal 'new name', client.name
        assert_equal 'http://new.example.com/cb', client.redirect_uri
      end
      
      
      def test_edit_should_populate_form_with_correct_client_info
        client = OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
        get :edit, :id => client.id

        assert_select "form" do
          assert_select "input[type='text'][name='oauth_client[name]'][value='#{client.name}']"
          assert_select "input[type='text'][name='oauth_client[redirect_uri]'][value='#{client.redirect_uri}']"
        end
      end
      
      def test_show_should_render_correct_client_info
        client = OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
        get :show, :id => client.id
        
        assert_select 'p', :text => /original name/
        assert_select 'p', :text => Regexp.new('http://old.example.com/cb')
        assert_select 'p', :text => /#{client.client_id}/
        assert_select 'p', :text => /#{client.client_secret}/
      end
      
    end #class OauthClientsControllerTest
  end #module Provider
end #module Oauth2
