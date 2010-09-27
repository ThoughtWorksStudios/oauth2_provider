# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

class OauthClientsControllerTest < ActionController::TestCase

  def setup
    @user = User.create!(:email => 'foo@bar.com', :password => 'top-secret')
    session[:user_id] = @user.id
  end

  def test_should_error_on_accessing_over_http
    @request.env["HTTPS"] = nil
    get :index
    assert_response :forbidden

    post :create
    assert_response :forbidden

    post :update
    assert_response :forbidden

    post :edit
    assert_response :forbidden

    get :show
    assert_response :forbidden

    delete :destroy
    assert_response :forbidden
  end

  def test_index_shows_all_clients
    @request.env['HTTPS'] = "on"
    client1 = Oauth2::Provider::OauthClient.create!(:name => 'name1', :redirect_uri => 'http://example1.com')
    client2 = Oauth2::Provider::OauthClient.create!(:name => 'name2', :redirect_uri => 'http://example2.com')

    get :index
    assert_response :ok

    assert_select "table" do
      assert_select "td", :text => 'name1'
      assert_select "td", :text => 'http://example1.com'
      assert_select "td", :text => Regexp.new(client1.client_id)
      assert_select "td", :text => Regexp.new(client1.client_secret)

      assert_select "td", :text => 'name2'
      assert_select "td", :text => 'http://example2.com'
      assert_select "td", :text => Regexp.new(client2.client_id)
      assert_select "td", :text => Regexp.new(client2.client_secret)
    end
  end

  def test_create_creates_new_oauth_client
    @request.env['HTTPS'] = "on"
    post :create, :oauth_client => {:name => 'my application', :redirect_uri => 'http://api.example.com/cb'}
    assert_redirected_to :controller => :oauth_clients

    assert_equal 1, Oauth2::Provider::OauthClient.all.size
    assert !Oauth2::Provider::OauthClient.all.first.client_id.blank?
    assert !Oauth2::Provider::OauthClient.all.first.client_secret.blank?
    assert_equal 'my application', Oauth2::Provider::OauthClient.all.first.name
    assert_equal 'http://api.example.com/cb', Oauth2::Provider::OauthClient.all.first.redirect_uri
  end

  def test_should_not_create_oauth_client_without_name_or_redirect_uri
    @request.env['HTTPS'] = "on"
    post :create, :oauth_client => {:name => 'my application'}
    assert_response :ok
    assert_equal 0, Oauth2::Provider::OauthClient.count

    post :create, :oauth_client => {:redirect_uri => 'http://api.example.com/cb'}
    assert_response :ok
    assert_equal 0, Oauth2::Provider::OauthClient.count
  end

  def test_update_writes_new_attributes
    @request.env['HTTPS'] = "on"
    client = Oauth2::Provider::OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
    post :update, :id => client.id, :oauth_client => {:name => 'new name', :redirect_uri => 'http://new.example.com/cb'}
    assert_redirected_to :controller => :oauth_clients
    client.reload
    assert_equal 'new name', client.name
    assert_equal 'http://new.example.com/cb', client.redirect_uri
  end


  def test_edit_should_populate_form_with_correct_client_info
    client = Oauth2::Provider::OauthClient.create!(:name => 'original name', :redirect_uri => 'http://old.example.com/cb')
    @request.env['HTTPS'] = "on"
    get :edit, :id => client.id
    assert_response :ok

    assert_select "form" do
      assert_select "input[type='text'][name='oauth_client[name]'][value='#{client.name}']"
      assert_select "input[type='text'][name='oauth_client[redirect_uri]'][value='#{client.redirect_uri}']"
    end
  end

end #class OauthClientsControllerTest
