require 'test_helper'

class OauthAuthorizeControllerTest < ActionController::TestCase
  
  def test_index_contains_hidden_fields_for_client_id_and_redirect_uri
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    get :index, :redirect_uri => 'http://example.com/cb', :client_id => client.client_id
    
    assert_select '#oauth_authorize' do 
      assert_select "#client_id[value='#{client.client_id}']"
      assert_select "#redirect_uri[value='http://example.com/cb']"
    end
  end

  def test_index_redirects_with_error_code_when_bogus_client_id_passed
    session[:user_id] = "13"
    get :index, :redirect_uri => 'http://example.com/cb', :client_id => 'bogus'
    assert_redirected_to 'http://example.com/cb?error=invalid-client-id'
  end
  
  def test_index_redirects_with_error_code_when_no_client_id_passed
    session[:user_id] = "13"
    get :index, :redirect_uri => 'http://example.com/cb'
    assert_redirected_to 'http://example.com/cb?error=invalid-request'
  end
  
  def test_index_returns_400_if_no_redirect_uri_is_supplied
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    get :index, :client_id => client.client_id, :authorize => '1'
    assert_response 400
  end
  
###  

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
  
  def test_authorize_should_return_authorization_code_if_user_authorizes_it
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id, :authorize => '1'

    assert_response :redirect
    assert @response.redirected_to  =~ /http\:\/\/example\.com\/cb\?code\=.*/
  end

  def test_authorize_returns_400_if_no_redirect_uri_is_supplied
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :client_id => client.client_id, :authorize => '1'
    
    assert_response 400
  end
    
  def test_authorize_should_return_access_denied_error_if_user_does_not_authorize
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id

    assert_redirected_to 'http://example.com/cb?error=access-denied'
  end
  
  def test_authorize_subsequent_requests_for_authorization_code_receive_unique_codes
    client = OauthClient.create!(:name => 'my application')
    session[:user_id] = '13'
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id, :authorize => '1'

    auth_response_1 = @response.redirected_to
    
    @request = ActionController::TestRequest.new
    post :authorize, :redirect_uri => 'http://example.com/cb', 
      :client_id => client.client_id, :authorize => '1'
    
    auth_response_2 = @response.redirected_to
    
    assert auth_response_1 != auth_response_2
  end

end
