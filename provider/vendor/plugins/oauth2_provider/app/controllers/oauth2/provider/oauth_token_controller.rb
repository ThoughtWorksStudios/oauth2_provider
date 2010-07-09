module Oauth2
  module Provider
    class OauthTokenController < ApplicationController

      skip_before_filter :login_required, :only => ['get_token']
  
      def get_token
    
        unless params[:grant_type] == 'authorization-code'
          render_error('unsupported-grant-type')
          return
        end
    
        client = OauthClient.find_by_client_id_and_client_secret(
          params[:client_id], params[:client_secret]
        )
    
        if client.nil?
          render_error('invalid-client-credentials')
          return
        end
    
        if client.redirect_uri != params[:redirect_uri]
          render_error('invalid-grant')
          return
        end
    
        authorization = client.oauth_authorizations.find_by_code(params[:code])

        if authorization.nil? || authorization.expired?
          render_error('invalid-grant')
          return
        end
    
        token = authorization.generate_access_token
        render :content_type => 'application/json', :text => token.access_token_attributes.to_json
      end
  
      private
      def render_error(error_code)
         render :status => :bad_request, :json => {:error => error_code}.to_json
      end
  
    end
  end
end