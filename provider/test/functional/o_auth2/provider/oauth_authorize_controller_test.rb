require File.join(File.dirname(__FILE__), '../../../test_helper')

module Oauth2
  module Provider
    class OauthAuthorizeControllerTest < ActionController::TestCase
  
      def setup
        @client = OauthClient.create!(:name => 'my application', :redirect_uri => 'http://example.com/cb')
        @user = User.create!(:email => 'foo@bar.com', :password => 'top-secret')
        Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
      end
  
      def teardown
        Clock.reset
      end
  
      def test_index_contains_hidden_fields_for_client_id_and_redirect_uri_and_response_type_and_state
        session[:user_id] = @user.id
        get :index, :redirect_uri => 'http://example.com/cb', :client_id => @client.client_id,
          :response_type => 'code', :state => 'some-state'
    
        assert_select '#oauth_authorize' do 
          assert_select "#client_id[value='#{@client.client_id}']"
          assert_select "#redirect_uri[value='http://example.com/cb']"
          assert_select "#response_type[value='code']"
          assert_select "#state[value='some-state']"
        end
      end
  
      def test_index_redirects_with_error_code_when_bogus_response_type_passed
        session[:user_id] = @user.id
        get :index, :redirect_uri => 'http://example.com/cb', :client_id => @client.client_id,
          :response_type => 'bogus'
    
        assert_redirected_to 'http://example.com/cb?error=unsupported-response-type'
      end
  
      def test_index_redirects_with_error_code_when_empty_response_type_passed
        session[:user_id] = @user.id
        get :index, :redirect_uri => 'http://example.com/cb', :client_id => @client.client_id
    
        assert_redirected_to 'http://example.com/cb?error=invalid-request'
      end

      def test_index_redirects_with_error_code_when_bogus_client_id_passed
        session[:user_id] = @user.id
        get :index, :redirect_uri => 'http://example.com/cb', :client_id => 'bogus',
          :response_type => 'code'
        assert_redirected_to 'http://example.com/cb?error=invalid-client-id'
      end
  
      def test_index_redirects_with_error_code_when_no_client_id_passed
        session[:user_id] = @user.id
        get :index, :redirect_uri => 'http://example.com/cb',
          :response_type => 'code'
        assert_redirected_to 'http://example.com/cb?error=invalid-request'
      end
  
      def test_index_returns_400_if_no_redirect_uri_is_supplied
        client = OauthClient.create!(:name => 'my application', :redirect_uri => 'http://example.com/cb')
        session[:user_id] = '13'
        get :index, :client_id => @client.client_id, :authorize => '1',
          :response_type => 'code'
        assert_response :bad_request
      end
  
      def test_index_redirects_with_error_code_when_mismatched_uri
        client = OauthClient.create!(:name => 'my application', :redirect_uri => 'http://example.com/cb')
        session[:user_id] = '13'
        get :index, :redirect_uri => 'bogus', :client_id => @client.client_id,
          :response_type => 'code'
    
        assert_redirected_to 'bogus?error=redirect-uri-mismatch'
      end

      def test_authorize_redirects_with_error_code_when_bogus_response_type_passed
        session[:user_id] = @user.id
        post :authorize, :redirect_uri => 'http://example.com/cb', :client_id => @client.client_id,
          :response_type => 'bogus'
    
        assert_redirected_to 'http://example.com/cb?error=unsupported-response-type'
      end
  
      def test_authorize_redirects_with_error_code_when_empty_response_type_passed
        session[:user_id] = @user.id
        post :authorize, :redirect_uri => 'http://example.com/cb', :client_id => @client.client_id
    
        assert_redirected_to 'http://example.com/cb?error=invalid-request'
      end
  
      def test_authorize_redirects_with_error_code_when_bogus_client_id_passed
        session[:user_id] = @user.id
        post :authorize, :redirect_uri => 'http://example.com/cb', :client_id => 'bogus',
          :response_type => 'code'
        assert_redirected_to 'http://example.com/cb?error=invalid-client-id'
      end
  
      def test_authorize_redirects_with_error_code_when_no_client_id_passed
        session[:user_id] = @user.id
        post :authorize, :redirect_uri => 'http://example.com/cb', :response_type => 'code'
        assert_redirected_to 'http://example.com/cb?error=invalid-request'
      end
  
      def test_authorize_should_return_authorization_code_with_expiry_if_user_authorizes_it_and_state_param_is_not_provided
        session[:user_id] = '13'
        post :authorize, :redirect_uri => 'http://example.com/cb', 
          :client_id => @client.client_id, :authorize => '1', :response_type => 'code'

        assert_response :redirect
        @client.reload
        authorization = @client.oauth_authorizations.first
        assert_equal "http://example.com/cb?code=#{authorization.code}&expires_in=#{authorization.expires_in}",
          @response.redirected_to
      end

      def test_authorize_should_return_authorization_code_with_expiry_and_state_if_user_authorizes_it_and_state_param_is_provided
        session[:user_id] = '13'
        post :authorize, :redirect_uri => 'http://example.com/cb',
          :client_id => @client.client_id, :authorize => '1', :response_type => 'code', :state => 'foo&bar'

        assert_response :redirect
        @client.reload
        authorization = @client.oauth_authorizations.first
        assert_equal "http://example.com/cb?code=#{authorization.code}&expires_in=#{authorization.expires_in}&state=foo%26bar",
          @response.redirected_to
      end
      
      def test_authorize_returns_400_if_no_redirect_uri_is_supplied
        session[:user_id] = '13'
        post :authorize, :client_id => @client.client_id, :authorize => '1', :response_type => 'code'
    
        assert_response 400
      end
  
      def test_authorize_redirects_with_error_code_when_mismatched_uri
        session[:user_id] = '13'
        get :index, :redirect_uri => 'bogus', :client_id => @client.client_id, :response_type => 'code'
    
        assert_redirected_to 'bogus?error=redirect-uri-mismatch'
      end
      
      def test_authorize_should_return_access_denied_error_if_user_does_not_authorize
        session[:user_id] = '13'
        post :authorize, :redirect_uri => 'http://example.com/cb', 
          :client_id => @client.client_id, :response_type => 'code'

        assert_redirected_to 'http://example.com/cb?error=access-denied'
      end
  
      def test_authorize_subsequent_requests_for_authorization_code_receive_unique_codes
        session[:user_id] = '13'
        post :authorize, :redirect_uri => 'http://example.com/cb', 
          :client_id => @client.client_id, :authorize => '1', :response_type => 'code'

        auth_response_1 = @response.redirected_to
    
        @request = ActionController::TestRequest.new
        post :authorize, :redirect_uri => 'http://example.com/cb', 
          :client_id => @client.client_id, :authorize => '1', :response_type => 'code'
    
        auth_response_2 = @response.redirected_to
    
        assert auth_response_1 != auth_response_2
      end

    end
  end
end