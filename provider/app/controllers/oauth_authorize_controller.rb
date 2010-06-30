class OauthAuthorizeController < ApplicationController

  include OauthProviderHelper
  
  def authorize
    if params[:client_id].blank?
      redirect_to "#{redirect_uri}?error=invalid-request"
      return
    end
    
    client = OauthClient.find_by_client_id(client_id)
    
    if client.nil?
      redirect_to "#{redirect_uri}?error=invalid-client-id"
      return
    end
    
    unless params[:authorize] == '1'
      redirect_to "#{redirect_uri}?error=access-denied"
      return
    end
    
    redirect_to "#{redirect_uri}?code=#{SecureRandom.random_bytes}"

  end
  
end
