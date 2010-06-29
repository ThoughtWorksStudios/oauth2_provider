class OauthAuthorizeController < ApplicationController

  include OauthProviderHelper
  
  def index
    # render :text => 'hello!'
  
    client = OauthClient.find_by_client_id_and_redirect_uri(client_id, redirect_uri)
    if !logged_in?
      redirect_to '/login'
    else
      # ask confirmation
      code = 'something'
      redirect_to "#{client.redirect_uri}?code=#{code}"
    end
    
    render :text => 'hello!'
  end
  
end
