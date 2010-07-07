# require 'o_auth2/provider/o_auth_clients_controller'
ActionController::Routing::Routes.draw do |map|
  
  map.resources :o_auth_clients, :controller => 'OAuth2::Provider::OAuthClients', :as => 'oauth/clients'
  
  map.connect '/oauth/authorize', :controller => 'OAuth2::Provider::OAuthAuthorize', :action => :authorize, :condition => {:method => :post}
  map.connect '/oauth/authorize', :controller => 'OAuth2::Provider::OAuthAuthorize', :action => :index, :condition => {:method => :get}
  map.connect '/oauth/token', :controller => 'OAuth2::Provider::OAuthToken', :action => :get_token
end
