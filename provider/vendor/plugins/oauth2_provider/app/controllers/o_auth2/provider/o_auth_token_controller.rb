module OAuth2
  module Provider
    class OAuthTokenController < ApplicationController

      skip_before_filter :login_required, :only => ['get_token']
  
      include OAuthProviderHelper
  
      def get_token
    
        unless params[:grant_type] == 'authorization-code'
          render_error('unsupported-grant-type')
          return
        end
    
        client = OAuthClient.find_by_client_id_and_client_secret(
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
    
        token = client.o_auth_tokens.find_by_authorization_code(authorization_code)

        if token.nil? || token.authorization_code_expired?
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
  end
end