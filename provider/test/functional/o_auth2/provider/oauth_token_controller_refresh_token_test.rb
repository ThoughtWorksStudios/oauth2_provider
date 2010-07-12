require File.join(File.dirname(__FILE__), '../../../test_helper')

module Oauth2
  module Provider
    class OauthTokenControllerRefreshTokenTest < ActionController::TestCase
  
      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 1, 2, 3)
        @client = OauthClient.create!(:name => 'my application', :redirect_uri => "http://example.com/cb")
        session[:user_id] = '13'
        @original_token = @client.create_token_for_user_id('13')
        @controller = OauthTokenController.new
      end
  
      def teardown
        Clock.reset
      end

      def test_get_token_happy_path_request_of_access_token
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'

        assert_response :success
    
        assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
        assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']

        token = ActiveSupport::JSON.decode(@response.body)
        assert_equal 64, token['access_token'].length
        assert_equal 90.days, token['expires_in']
        assert_equal 64, token['refresh_token'].length
        
        assert_not_equal token["access_token"], @original_token.access_token
        assert_not_equal token["refresh_token"], @original_token.refresh_token
        assert_nil OauthToken.find_by_id(@original_token.id)
      end
  
      def test_does_not_hand_out_oauth_token_twice_using_same_refresh_token_when_first_attempt_succeeded
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
    
        @request = ActionController::TestRequest.new

        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
    
        assert_get_token_error('invalid-grant')
      end
      
      def test_does_not_hand_out_oauth_token_twice_using_same_refresh_token_when_first_attempt_failed
        post :get_token, :client_id => @client.client_id, :client_secret => 'bogus client secret to trigger failure',
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
    
        @request = ActionController::TestRequest.new

        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
    
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_client_id
        post :get_token, :client_id => 'bad client id', :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_no_client_id
        post :get_token, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'

        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_bogus_client_secret
        post :get_token, :client_id => @client.client_id, :client_secret => 'bad client secret',
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_no_client_secret
        post :get_token, :client_id => @client.client_id,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
   
        assert_get_token_error('invalid-client-credentials')
      end
  
      def test_get_token_returns_error_when_passed_bogus_refresh_token
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => 'bad request token', :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
   
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_no_refresh_token
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :redirect_uri => "http://example.com/cb",
          :grant_type => 'refresh-token'
    
        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_redirect_uri
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "bad bad bad",
          :grant_type => 'refresh-token'

        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_no_redirect_uri
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token,
          :grant_type => 'refresh-token'

        assert_get_token_error('invalid-grant')
      end
  
      def test_get_token_returns_error_when_passed_bogus_grant
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb",
          :grant_type => 'bogus'
        assert_get_token_error('unsupported-grant-type')
      end
  
      def test_get_token_returns_error_when_passed_no_grant
        post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/cb"
          
        assert_get_token_error('unsupported-grant-type')
      end
      
      def test_get_token_returns_error_code_when_mismatch_between_client_and_refresh_token
        another_client = OauthClient.create!(:name => 'another client', :redirect_uri => 'http://example.com/another_cb')
        post :get_token, :client_id => another_client.client_id, :client_secret => another_client.client_secret,
          :refresh_token => @original_token.refresh_token, :redirect_uri => "http://example.com/another_cb",
          :grant_type => 'refresh-token'

        assert_get_token_error('invalid-grant')
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