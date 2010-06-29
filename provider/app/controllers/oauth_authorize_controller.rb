class OauthAuthorizeController < ApplicationController

  include OauthProviderHelper
  
  def index
    # render :text => 'hello!'
  
    OauthClient.find_by_client_id_and_redirect_uri(client_id, redirect_uri)
    render :text => 'hello!'
  end
  
end
