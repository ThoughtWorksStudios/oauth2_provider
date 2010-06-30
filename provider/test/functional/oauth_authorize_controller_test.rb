require 'test_helper'

class OauthAuthorizeControllerTest < ActionController::TestCase

  def test_index_redirects_with_error_code_when_bogus_client_id_passed
    # later ..
  end
  
  def test_authorize_redirects_with_error_code_when_bogus_client_id_passed
    session[:user_id] = "13"
    post :authorize, :redirect_uri => 'http://example.com/cb', :client_id => 'bogus'
    assert_redirected_to 'http://example.com/cb?error=invalid-client-id'
  end
  
  def test_authorize_redirects_with_error_code_when_no_client_id_passed
    session[:user_id] = "13"
    post :authorize, :redirect_uri => 'http://example.com/cb'
    assert_redirected_to 'http://example.com/cb?error=invalid-request'
  end
  
  def test_should_return_authorization_code_if_user_authorizes_it
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id, :authorize => '1'

    assert_response :redirect
    assert @response.redirected_to  =! /http\:\/\/example\.com\/cb\?code\=.*/
  end
  
  def test_should_return_access_denied_error_if_user_does_not_authorize
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id

    assert_redirected_to 'http://example.com/cb?error=access-denied'
  end
  
  
end
