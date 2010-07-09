require 'test_helper'

module Oauth2
  module Provider
    
    class OauthUserTokensControllerTest < ActionController::TestCase     
      
      
      def test_index_shows_tokens_only_for_logged_in_user
        client1 = OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
        client2 = OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

        user1 = User.create!(:email => 'u1', :password => 'p1')
        token1 = client1.create_token_for_user_id(user1.id)
        token2 = client2.create_token_for_user_id(user1.id)
        
        user2 = User.create!(:email => 'u2', :password => 'p2')
        token3 = client1.create_token_for_user_id(user2.id)
        
        session[:user_id] = user1.id
        
        get :index
        
        assert_select "table" do
          assert_select "tr", :count => 2
          
          assert_select 'tr' do
            assert_select "td", "some application"
            assert_select "td", token1.access_token
            assert_select "a[href='#{@controller.url_for(:action=>:revoke, :only_path => true, :token_id => token1.id)}']"
          end
          
          assert_select 'tr' do
            assert_select "td", "another application"
            assert_select "td", token2.access_token
            assert_select "a[href='#{@controller.url_for(:action=>:revoke, :only_path => true, :token_id => token2.id)}']"
          end
        end
        
      end

      def test_revoke_destroys_users_token
        user1 = User.create!(:email => 'u1', :password => 'p1')
        client1 = OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
        token1 = client1.create_token_for_user_id(user1.id)
        token2 = client1.create_token_for_user_id(user1.id)
        session[:user_id] = user1.id
        
        post :revoke, :token_id => token1.id
        
        assert_nil OauthToken.find_by_id(token1.id)
        assert_not_nil OauthToken.find_by_id(token2.id)
      end

      def test_revoke_returns_bad_request_code_if_user_does_not_own_token
        client1 = OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
        client2 = OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

        user1 = User.create!(:email => 'u1', :password => 'p1')
        token1 = client1.create_token_for_user_id(user1.id)
        token2 = client2.create_token_for_user_id(user1.id)
        
        user2 = User.create!(:email => 'u2', :password => 'p2')
        token3 = client1.create_token_for_user_id(user2.id)
        
        session[:user_id] = user1.id
        
        post :revoke, :token_id => token3.id
        assert_response :bad_request
      end
      
      def test_revoke_returns_bad_request_code_if_token_id_is_not_passed
        session[:user_id] = '13'
        post :revoke
        
        assert "User not authorized to perform this action!", @response.body
        assert_response :bad_request
      end
      
      def test_revoke_returns_bad_request_code_if_token_id_is_bogus
        session[:user_id] = '13'
        post :revoke, :token_id => 998

        assert "User not authorized to perform this action!", @response.body
        assert_response :bad_request
      end

    end
  end
end