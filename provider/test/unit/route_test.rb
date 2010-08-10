# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

class RouteTest < ActionController::TestCase
  def teardown
    ENV['ADMIN_OAUTH_URL_PREFIX'] = ENV['USER_OAUTH_URL_PREFIX'] = ''
    load_route_file
  end

  def load_route_file
    ActionController::Routing::Routes.clear!
    load File.join(File.dirname(__FILE__), "../../vendor/plugins/oauth2_provider/config/routes.rb")
  end

  def test_uses_admin_scope_if_given
    assert_routing '/oauth/clients', { :controller => "Oauth2::Provider::OauthClients", :action => "index"}
    ENV['ADMIN_OAUTH_URL_PREFIX'] = 'admin/namespace/'
    load_route_file
    assert_routing '/admin/namespace/oauth/clients', { :controller => "Oauth2::Provider::OauthClients", :action => "index"}
    assert_routing '/oauth/user_tokens', { :controller => "Oauth2::Provider::OauthUserTokens", :action => "index"}
    assert_routing '/oauth/authorize', { :controller => "Oauth2::Provider::OauthAuthorize", :action => "index"}
  end

  def test_uses_user_scope_if_given
    assert_routing '/oauth/clients', { :controller => "Oauth2::Provider::OauthClients", :action => "index"}
    ENV['USER_OAUTH_URL_PREFIX'] = '/user/namespace'
    load_route_file
    assert_routing '/user/namespace/oauth/user_tokens', { :controller => "Oauth2::Provider::OauthUserTokens", :action => "index"}
    assert_routing '/user/namespace/oauth/authorize', { :controller => "Oauth2::Provider::OauthAuthorize", :action => "index"}
    assert_routing '/oauth/clients', { :controller => "Oauth2::Provider::OauthClients", :action => "index"}
  end
end
