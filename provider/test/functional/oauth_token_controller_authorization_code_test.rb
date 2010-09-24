# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

class OauthTokenControllerAuthorizationCodeTest < ActionController::TestCase

  def setup
    Oauth2::Provider::Clock.fake_now = Time.utc(2008, 1, 20, 1, 2, 3)
    @client = Oauth2::Provider::OauthClient.create!(:name => 'my application', :redirect_uri => "http://example.com/cb")
    session[:user_id] = '13'
    @authorization = @client.create_authorization_for_user_id('13')
    @controller = OauthTokenController.new
  end

  def teardown
    Oauth2::Provider::Clock.reset
  end

  def test_get_token_happy_path_request_of_access_token
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_response :success

    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']

    token = ActiveSupport::JSON.decode(@response.body)
    assert_equal 64, token['access_token'].length
    assert_equal 90.days, token['expires_in']
    assert_equal 64, token['refresh_token'].length
  end

  def test_does_not_hand_out_oauth_token_twice_using_same_authorization_code_when_first_attempt_succeeded
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    @request = ActionController::TestRequest.new

    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end
  
  def test_does_not_hand_out_oauth_token_twice_using_same_authorization_code_when_first_attempt_failed
    post :get_token, :client_id => @client.client_id, :client_secret => 'bogus secret to trigger failure',
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    @request = ActionController::TestRequest.new

    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def test_does_not_hand_out_oauth_token_after_authorization_code_expires
    Oauth2::Provider::Clock.fake_now = Oauth2::Provider::Clock.now + 1.hour + 1.second
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'
  
    assert_get_token_error('invalid-grant')
  end

  def test_get_token_returns_error_when_passed_bogus_client_id
    post :get_token, :client_id => 'bogus', :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-client-credentials')
  end

  def test_get_token_returns_error_when_passed_no_client_id
    post :get_token, :client_secret => @client.client_secret,
       :code => @authorization.code, :redirect_uri => "http://example.com/cb",
       :grant_type => 'authorization-code'

    assert_get_token_error('invalid-client-credentials')
  end

  def test_get_token_returns_error_when_passed_bogus_client_secret
    post :get_token, :client_id => @client.client_id, :client_secret => 'bogus',
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-client-credentials')
  end

  def test_get_token_returns_error_when_passed_no_client_secret
    post :get_token, :client_id => @client.client_id,
      :code => @authorization.code, :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-client-credentials')
  end

  def test_get_token_returns_error_when_passed_bogus_authorization_code
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => 'bogus', :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def test_get_token_returns_error_when_passed_noauthorization_code
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :redirect_uri => "http://example.com/cb",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def test_get_token_returns_error_when_passed_bogus_redirect_uri
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code, :redirect_uri => "bogus",
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def test_get_token_returns_error_when_passed_no_redirect_uri
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret,
      :code => @authorization.code,
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def test_get_token_returns_error_when_passed_bogus_grant
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret, 
      :redirect_uri => "http://example.com/cb", :code => @authorization.code,
      :grant_type => 'bogus'
    assert_get_token_error('unsupported-grant-type')
  end

  def test_get_token_returns_error_when_passed_no_grant
    post :get_token, :client_id => @client.client_id, :client_secret => @client.client_secret, 
      :redirect_uri => "http://example.com/cb", :code => @authorization.code
    assert_get_token_error('unsupported-grant-type')
  end
  
  def test_get_token_returns_error_code_when_mismatch_between_client_and_code
    another_client = Oauth2::Provider::OauthClient.create!(:name => 'another client', :redirect_uri => 'http://example.com/another_cb')
    post :get_token, :client_id => another_client.client_id, :client_secret => another_client.client_secret,
      :code => @authorization.code, :redirect_uri => 'http://example.com/another_cb',
      :grant_type => 'authorization-code'

    assert_get_token_error('invalid-grant')
  end

  def assert_get_token_error(expected_error)
    assert_response :bad_request
    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert @response.headers['Cache-Control'] =~ /no-cache|private, max-age=0, must-revalidate/
    assert_equal expected_error, ActiveSupport::JSON.decode(@response.body)['error']
  end
end
