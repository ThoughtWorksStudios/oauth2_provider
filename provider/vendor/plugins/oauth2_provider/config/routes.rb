# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

ActionController::Routing::Routes.draw do |map|

  admin_prefix=ENV['ADMIN_OAUTH_URL_PREFIX']

  map.resources :oauth_clients, :controller => 'oauth2/provider/oauth_clients', :as => "#{admin_prefix}oauth/clients"

  user_prefix=ENV['USER_OAUTH_URL_PREFIX']

  map.connect "#{user_prefix}/oauth/authorize", :controller => 'oauth2/provider/oauth_authorize', :action => :authorize, :conditions => {:method => :post}
  map.connect "#{user_prefix}/oauth/authorize", :controller => 'oauth2/provider/oauth_authorize', :action => :index, :conditions => {:method => :get}
  map.connect "#{user_prefix}/oauth/token", :controller => 'oauth2/provider/oauth_token', :action => :get_token, :conditions => {:method => :post}

  map.connect "#{user_prefix}/oauth/user_tokens/revoke/:token_id", :controller => 'oauth2/provider/oauth_user_tokens', :action => :revoke, :conditions => {:method => :delete}
  map.connect "#{user_prefix}/oauth/user_tokens", :controller => 'oauth2/provider/oauth_user_tokens', :action => :index, :conditions => {:method => :get}

end
