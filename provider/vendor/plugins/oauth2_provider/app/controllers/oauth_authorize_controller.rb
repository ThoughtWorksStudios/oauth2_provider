class OauthAuthorizeController < ApplicationController

  include OauthProviderHelper
  
  def index
    return unless validate_params
  end
  
  def authorize
    return unless validate_params
    
    unless params[:authorize] == '1'
      redirect_to "#{redirect_uri}?error=access-denied"
      return
    end
    
    redirect_to "#{redirect_uri}?code=#{ActiveSupport::SecureRandom.hex(32)}"
  end
  
  private
  
  def validate_params
    if params[:client_id].blank?
      redirect_to "#{redirect_uri}?error=invalid-request"
      return false
    end
    
    if params[:redirect_uri].blank?
      render :text => "You did not specify the 'redirect_uri' parameter!", :status => :bad_request
      return false
    end
    
    client = OauthClient.find_by_client_id(client_id)
    
    if client.nil?
      redirect_to "#{redirect_uri}?error=invalid-client-id"
      return false
    end
    
    if client.redirect_uri != redirect_uri
      redirect_to "#{redirect_uri}?error=redirect-uri-mismatch"
      return false
    end
    
    true
  end
  
end
