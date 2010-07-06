require 'test_helper'

module OAuth2
  module Provider
    class OAuthTokenControllerTest < ActionController::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 1, 2, 3)
        @client = OAuthClient.create!(:name => 'my application', :redirect_uri => "http://example.com/cb")
        session[:user_id] = '13'
        @client.oauth_tokens.create!(:user_id => 13, :authorization_code => 'valid_authorization_code')
      end
  
      def teardown
        Clock.reset
      end

      def test_get_token_happy_path_request_of_access_token
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'

        assert_response :success
    
        assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
        assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']

        token = ActiveSupport::JSON.decode(@response.body)
        assert_equal 64, token['access_token'].length
        assert_equal 90.days, token['expires_in']
        assert_equal 64, token['refresh_token'].length
      end
  
      def test_does_not_hand_out_oauth_token_twice_using_same_authorization_code
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
    
        @request = ActionController::TestRequest.new

        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
    
        assert_get_token_error('invalid-grant')
      end
  
      def test_does_not_hand_out_oauth_token_after_authorization_code_expires
        Clock.fake_now = Clock.now + 1.hour + 1.second
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
      
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_client_id
        post :get_token, :client_id => 'bogus', :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_no_client_id
        post :get_token, :client_secret => @client.client_secret,
           :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
           :grant_type => 'authorization-code'

        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_bogus_client_secret
        post :get_token, :client_id => @client.client_id, :client_secret => 'bogus',
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_no_client_secret
        post :get_token, :client_id => @client.client_id,
          :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_bogus_authorization_code
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'bogus', :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
   
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_no_authorization_code
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :redirect_uri => "http://example.com/cb",
          :grant_type => 'authorization-code'
    
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_redirect_uri
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code', :redirect_uri => "bogus",
          :grant_type => 'authorization-code'

        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_no_redirect_uri
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :code => 'valid_authorization_code',
          :grant_type => 'authorization-code'

        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_grant
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret, 
          :redirect_uri => "http://example.com/cb", :code => 'valid_authorization_code',
          :grant_type => 'bogus'
        assert_get_token_error('unsupported-grant-type')
      end
  
      def test_get_token_returns_error_when_passed_no_grant
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret, 
          :redirect_uri => "http://example.com/cb", :code => 'valid_authorization_code'
        assert_get_token_error('unsupported-grant-type')
      end
  
      def assert_get_token_error(expected_error)
        assert_response :bad_request
        assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
        assert @response.headers['Cache-Control'] =~ /no-cache|private, max-age=0, must-revalidate/
        assert_equal expected_error, ActiveSupport::JSON.decode(@response.body)['error']
      end
    end
  end
end