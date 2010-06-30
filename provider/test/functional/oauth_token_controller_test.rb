require 'test_helper'

class OauthTokenControllerTest < ActionController::TestCase

  def test_happy_path_request_of_access_token
    client = OauthClient.create!(:name => 'my application', :redirect_uri => "http://example.com/cb")
    session[:user_id] = '13'
    client.oauth_tokens.create!(:user_id => 13, :authorization_code => 'valid_authorization_code')
    post :get_token, :client_id => client.client_id, :client_secret => client.client_secret,
      :authorization_code => 'valid_authorization_code', :redirect_uri => "http://example.com/cb"

    assert_response :success
    
    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']

    token = ActiveSupport::JSON.decode(@response.body)
    assert !token['access_token'].blank?
    assert !token.key?('expires_in')
    assert !token.key?('refresh_token')
  end
  
end
