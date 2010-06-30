require 'test_helper'

class OauthTokenControllerTest < ActionController::TestCase
  
  def setup
    @client = OauthClient.create!(:name => 'my application', :redirect_uri => "http://example.com/cb")
    session[:user_id] = '13'
    @client.oauth_tokens.create!(:user_id => 13, :authorization_code => 'valid_authorization_code')
  end

  def test_get_token_happy_path_request_of_access_token
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"

    assert_response :success
    
    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']

    token = ActiveSupport::JSON.decode(@response.body)
    assert !token['access_token'].blank?
    assert !token.key?('expires_in')
    assert !token.key?('refresh_token')
  end
  
  def test_get_token_returns_error_when_passed_bogus_client_id
    post :get_token, :client_id => 'bogus', :client_secret => @client.client_secret,
      :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"
   
    assert_get_token_error('invalid-client-credentials')
  end
  
  def test_get_token_returns_error_when_passed_no_client_id
    post :get_token, :client_secret => @client.client_secret,
       :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"

    assert_get_token_error('invalid-client-credentials')
  end
  
  def test_get_token_returns_error_when_passed_bogus_client_secret
    post :get_token, :client_id => @client.client_id, :client_secret => 'bogus',
      :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"
   
    assert_get_token_error('invalid-client-credentials')
  end
  
  def test_get_token_returns_error_when_passed_no_client_secret
    post :get_token, :client_id => @client.client_id,
      :code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"
   
    assert_get_token_error('invalid-client-credentials')
  end
  
  def test_get_token_returns_error_when_passed_bogus_authorization_code
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => 'bogus', :redirect_uri => "http://example.com/cb"
   
    assert_get_token_error('invalid-grant')
  end
  
  def test_get_token_returns_error_when_passed_no_authorization_code
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :redirect_uri => "http://example.com/cb"
    
    assert_get_token_error('invalid-grant')
  end
  
  def test_get_token_returns_error_when_passed_bogus_redirect_uri
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => 'valid_authorization_code', :redirect_uri => "bogus"

    assert_get_token_error('invalid-grant')
  end
  
  def test_get_token_returns_error_when_passed_no_redirect_uri
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => 'valid_authorization_code'

    assert_get_token_error('invalid-grant')
  end
  
  private
  
  def assert_get_token_error(expected_error)
    assert_response :bad_request
    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert_equal "no-cache", @response.headers['Cache-Control']
    assert_equal expected_error, ActiveSupport::JSON.decode(@response.body)['error']
  end
  
end
