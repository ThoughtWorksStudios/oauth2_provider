# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

class OauthUserTokensControllerTest < ActionController::TestCase

  def test_should_disallow_access_over_http
    user1 = User.create!(:email => 'u1', :password => 'p1')
    session[:user_id] = user1.id

    get :index
    assert_response :forbidden

    get :revoke
    assert_response :forbidden
  end

  def test_provider_name_is_html_escaped
    client1 = Oauth2::Provider::OauthClient.create!(:name => '<h1>app</h1>', :redirect_uri => 'http://app1.com/bar')
    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    get :index

    assert_select 'table tr td', :text => '&lt;h1&gt;app&lt;/h1&gt;'
  end

  def test_index_shows_tokens_only_for_logged_in_user
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client2.create_token_for_user_id(user1.id)

    user2 = User.create!(:email => 'u2', :password => 'p2')
    token3 = client1.create_token_for_user_id(user2.id)

    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    get :index

    assert_select "table" do
      assert_select "tr", :count => 3

      assert_select "tr##{token1.access_token}" do
        assert_select "td", "some application"
        assert_select "a[href='#{@controller.url_for(:action=>:revoke, :only_path => true, :token_id => token1.id, :controller => 'oauth_user_tokens')}']"
      end

      assert_select "tr##{token2.access_token}" do
        assert_select "td", "another application"
        assert_select "a[href='#{@controller.url_for(:action=>:revoke, :only_path => true, :token_id => token2.id, :controller => 'oauth_user_tokens')}']"
      end
    end

  end

  def test_revoke_destroys_users_token
    user1 = User.create!(:email => 'u1', :password => 'p1')
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client1.create_token_for_user_id(user1.id)
    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    post :revoke, :token_id => token1.id
    
    assert_response :redirect
    assert_redirected_to :action => 'index'
    
    assert_equal "OAuth access token was successfully deleted.", flash[:notice]
    assert_nil Oauth2::Provider::OauthToken.find_by_id(token1.id)
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token2.id)
    
  end

  def test_revoke_returns_bad_request_code_if_user_does_not_own_token
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client2.create_token_for_user_id(user1.id)

    user2 = User.create!(:email => 'u2', :password => 'p2')
    token3 = client1.create_token_for_user_id(user2.id)

    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    post :revoke, :token_id => token3.id
    assert_response :bad_request
  end
  
  def test_revoke_returns_bad_request_code_if_token_id_is_not_passed
    user = User.create(:email => 'foo@example.com', :password => 'open!')
    session[:user_id] = user.id
    @request.env["HTTPS"] = 'on'
    post :revoke

    assert "User not authorized to perform this action!", @response.body
    assert_response :bad_request
  end

  def test_revoke_returns_bad_request_code_if_token_id_is_bogus
    user = User.create(:email => 'foo@example.com', :password => 'open!')
    session[:user_id] = user.id
    @request.env["HTTPS"] = 'on'
    post :revoke, :token_id => 998

    assert "User not authorized to perform this action!", @response.body
    assert_response :bad_request
  end
  
  def test_revoke_by_admin_deletes_token_regardless_of_ownership
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client2.create_token_for_user_id(user1.id)

    user2 = User.create!(:email => 'u2', :password => 'p2')
    token3 = client1.create_token_for_user_id(user2.id)

    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    post :revoke_by_admin, :token_id => token3.id
    
    assert_redirected_to :action => 'index'
    assert_equal "OAuth access token was successfully deleted.", flash[:notice]
    assert_nil Oauth2::Provider::OauthToken.find_by_id(token3.id)
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token1.id)
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token2.id)
  end
  

  def test_revoke_by_admin_returns_bad_request_code_if_token_id_is_bogus
    user = User.create(:email => 'foo@example.com', :password => 'open!')
    session[:user_id] = user.id
    @request.env["HTTPS"] = 'on'
    post :revoke_by_admin, :token_id => 998

    assert "User not authorized to perform this action!", @response.body
    assert_response :bad_request
  end
  
  def test_revoke_by_admin_deletes_all_tokens_for_a_user_regardless_of_ownership_when_passed_user_id
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client2.create_token_for_user_id(user1.id)

    user2 = User.create!(:email => 'u2', :password => 'p2')
    token3 = client1.create_token_for_user_id(user2.id)

    session[:user_id] = user2.id

    @request.env["HTTPS"] = 'on'

    post :revoke_by_admin, :user_id => user1.id
    assert_redirected_to :action => :index
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token3.id)
    assert_nil Oauth2::Provider::OauthToken.find_by_id(token1.id)
    assert_nil Oauth2::Provider::OauthToken.find_by_id(token2.id)
  end
  
  def test_revoke_by_admin_survives_when_passed_bogus_user_id
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user = User.create!(:email => 'u2', :password => 'p2')
    token = client1.create_token_for_user_id(user.id)

    session[:user_id] = user.id

    @request.env["HTTPS"] = 'on'

    post :revoke_by_admin, :user_id => 1233
    assert_redirected_to :action => :index
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token.id)
  end
  
  def test_revoke_by_admin_returns_bad_request_code_if_neither_token__nor_user_is_not_passed
    user = User.create(:email => 'foo@example.com', :password => 'open!')
    session[:user_id] = user.id
    @request.env["HTTPS"] = 'on'
    post :revoke_by_admin

    assert "User not authorized to perform this action!", @response.body
    assert_response :bad_request
  end
  
  def test_revoke_by_admin_honors_token_id_over_user_id
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'another application', :redirect_uri => 'http://app2.com/bar')

    user1 = User.create!(:email => 'u1', :password => 'p1')
    token1 = client1.create_token_for_user_id(user1.id)
    token2 = client2.create_token_for_user_id(user1.id)

    user2 = User.create!(:email => 'u2', :password => 'p2')
    token3 = client1.create_token_for_user_id(user2.id)

    session[:user_id] = user2.id

    @request.env["HTTPS"] = 'on'

    post :revoke_by_admin, :user_id => user1.id, :token_id => token3.id
    assert_redirected_to :action => :index
    assert_nil Oauth2::Provider::OauthToken.find_by_id(token3.id)
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token1.id)
    assert_not_nil Oauth2::Provider::OauthToken.find_by_id(token2.id)
  end
  
  def test_reovke_should_redirect_to_specified_url_if_redirect_url_param_is_given
    user1 = User.create!(:email => 'u1', :password => 'p1')
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    token1 = client1.create_token_for_user_id(user1.id)
    session[:user_id] = user1.id

    @request.env["HTTPS"] = 'on'
    post :revoke, :token_id => token1.id, :redirect_url => 'http://example.com'
    assert_redirected_to 'http://example.com'
  end
  
  def test_reovke_by_admin_should_redirect_to_specified_url_if_redirect_url_param_is_given
    admin = User.create!(:email => 'admin', :password => 'p1')
    user = User.create!(:email => 'u1', :password => 'p1')
    client = Oauth2::Provider::OauthClient.create!(:name => 'some application', :redirect_uri => 'http://app1.com/bar')
    token = client.create_token_for_user_id(user.id)
    session[:user_id] = admin.id
    @request.env["HTTPS"] = 'on'

    post :revoke_by_admin, :token_id => token.id, :redirect_url => 'http://example.com'

    assert_response :redirect
    assert_redirected_to 'http://example.com'
  end
  
  
end
