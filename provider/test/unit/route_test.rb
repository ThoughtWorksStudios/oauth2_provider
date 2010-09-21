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
    assert_routing '/oauth/clients', { :controller => "oauth2/provider/oauth_clients", :action => "index"}
    ENV['ADMIN_OAUTH_URL_PREFIX'] = 'admin/namespace/'
    load_route_file
    assert_routing '/admin/namespace/oauth/clients', { :controller => "oauth2/provider/oauth_clients", :action => "index"}
    assert_routing '/oauth/user_tokens', { :controller => "oauth2/provider/oauth_user_tokens", :action => "index"}
    assert_routing '/oauth/authorize', { :controller => "oauth2/provider/oauth_authorize", :action => "index"}
  end

  def test_uses_user_scope_if_given
    assert_routing '/oauth/clients', { :controller => "oauth2/provider/oauth_clients", :action => "index"}
    ENV['USER_OAUTH_URL_PREFIX'] = '/user/namespace'
    load_route_file
    assert_routing '/user/namespace/oauth/user_tokens', { :controller => "oauth2/provider/oauth_user_tokens", :action => "index"}
    assert_routing '/user/namespace/oauth/authorize', { :controller => "oauth2/provider/oauth_authorize", :action => "index"}
    assert_routing '/oauth/clients', { :controller => "oauth2/provider/oauth_clients", :action => "index"}
  end
end
