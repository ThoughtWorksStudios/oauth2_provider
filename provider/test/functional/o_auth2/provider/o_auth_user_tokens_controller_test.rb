require 'test_helper'

module OAuth2
  module Provider
    
    class OAuthUserTokensControllerTest < ActionController::TestCase     
      
      
      def test_index_shows_tokens_only_for_logged_in_user
        user1 = User.create!(:email => 'u1', :crypted_password => 'p1')
        user2 = User.create!(:email => 'u2', :crypted_password => 'p2')
        
        client1 = OAuthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
        client2 = OAuthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')
        
        token1 = client1.create_token_for_user_id(user1.id)
        
        token2 = client2.create_token_for_user_id(user1.id)
        
        token3 = client1.create_token_for_user_id(user2.id)
        
        session[:user_id] = user1.id
        
        get :index
        
        assert_select "table" do
          assert_select "tr", :count => 2
          
          assert_select 'tr' do
            assert_select "td", "some application"
            assert_select "td", token1.access_token
          end
          
          assert_select 'tr' do
            assert_select "td", "another application"
            assert_select "td", token2.access_token
          end
        end
        
      end
    end
    
  end
end