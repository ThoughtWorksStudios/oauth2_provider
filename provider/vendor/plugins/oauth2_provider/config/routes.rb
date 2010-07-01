ActionController::Routing::Routes.draw do |map|
  
  map.resources :oauth_clients
  map.connect '/oauth/authorize', :controller => :oauth_authorize
  map.connect '/oauth/token', :controller => :oauth_token, :action => :get_token
  
end
