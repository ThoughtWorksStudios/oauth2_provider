# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

ActionController::Routing::Routes.draw do |map|

  admin_prefix=ENV['ADMIN_OAUTH_URL_PREFIX']

  map.resources :oauth_clients, :controller => 'Oauth2::Provider::OauthClients', :as => "#{admin_prefix}oauth/clients"

  user_prefix=ENV['USER_OAUTH_URL_PREFIX']

  map.connect "#{user_prefix}/oauth/authorize", :controller => 'Oauth2::Provider::OauthAuthorize', :action => :authorize, :conditions => {:method => :post}
  map.connect "#{user_prefix}/oauth/authorize", :controller => 'Oauth2::Provider::OauthAuthorize', :action => :index, :conditions => {:method => :get}
  map.connect "#{user_prefix}/oauth/token", :controller => 'Oauth2::Provider::OauthToken', :action => :get_token, :conditions => {:method => :post}

  map.connect "#{user_prefix}/oauth/user_tokens/revoke/:token_id", :controller => 'Oauth2::Provider::OauthUserTokens', :action => :revoke, :conditions => {:method => :delete}
  map.connect "#{user_prefix}/oauth/user_tokens", :controller => 'Oauth2::Provider::OauthUserTokens', :action => :index, :conditions => {:method => :get}

end
