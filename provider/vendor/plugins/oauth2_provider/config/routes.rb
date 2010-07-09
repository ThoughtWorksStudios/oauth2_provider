# require 'oauth2/provider/oauth_clients_controller'
ActionController::Routing::Routes.draw do |map|
  
  map.resources :oauth_clients, :controller => 'Oauth2::Provider::OauthClients', :as => 'oauth/clients'
  
  map.connect '/oauth/authorize', :controller => 'Oauth2::Provider::OauthAuthorize', :action => :authorize, :conditions => {:method => :post}
  map.connect '/oauth/authorize', :controller => 'Oauth2::Provider::OauthAuthorize', :action => :index, :conditions => {:method => :get}
  map.connect '/oauth/token', :controller => 'Oauth2::Provider::OauthToken', :action => :get_token, :conditions => {:method => :post}
  
  map.connect '/oauth/user_tokens/revoke/:token_id', :controller => 'Oauth2::Provider::OauthUserTokens', :action => :revoke, :conditions => {:method => :delete}
  map.connect '/oauth/user_tokens', :controller => 'Oauth2::Provider::OauthUserTokens', :action => :index
end
