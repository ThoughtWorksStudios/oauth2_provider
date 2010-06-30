
ActionController::Routing::Routes.draw do |map|
  map.resources :oauth_clients
  map.connect '/oauth/authorize', :controller => :oauth_authorize
end