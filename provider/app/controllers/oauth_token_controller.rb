class OauthTokenController < ApplicationController

  skip_before_filter :login_required, :only => ['get_token']
  
  include OauthProviderHelper
  
  def get_token
    
    unless params[:grant_type] == 'authorization-code'
      render_error('unsupported-grant-type')
      return
    end
    
    client = OauthClient.find_by_client_id_and_client_secret(
      client_id, client_secret
    )
    
    if client.nil?
      render_error('invalid-client-credentials')
      return
    end
    
    if client.redirect_uri != redirect_uri
      render_error('invalid-grant')
      return
    end
    
    token = client.oauth_tokens.find_by_authorization_code(authorization_code)

    if token.nil? || token.expired?
      render_error('invalid-grant')
      return
    end
    
    token.generate_access_token!
    render :content_type => 'application/json', :text => token.access_token_attributes.to_json
  end
  
  private
  def render_error(error_code)
     render :status => :bad_request, :json => {:error => error_code}.to_json
  end
  
end
