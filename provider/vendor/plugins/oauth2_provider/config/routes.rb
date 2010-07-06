ActionController::Routing::Routes.draw do |map|
  
  map.resources :oauth_clients
  map.connect '/oauth/authorize', :controller => OAuth2::Provider::OAuthAuthorizeController
  map.connect '/oauth/token', :controller => OAuth2::Provider::OAuthTokenController, :action => :get_token
  
end
