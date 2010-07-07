module OAuth2
  module Provider
    class OAuthAuthorizeController < ::ApplicationController

      def index
        return unless validate_params
      end
  
      def authorize
        return unless validate_params
    
        unless params[:authorize] == '1'
          redirect_to "#{params[:redirect_uri]}?error=access-denied"
          return
        end
    
        token = @client.oauth_tokens.create!(
          :authorization_code => ::ActiveSupport::SecureRandom.hex(32),
          :user_id => current_user_id
        )
        state_param = if params[:state].blank?
          ""
        else
          "&state=#{CGI.escape(params[:state])}"
        end
        
        redirect_to "#{params[:redirect_uri]}?code=#{token.authorization_code}&expires_in=#{token.authorization_code_expires_in}#{state_param}"
      end
  
      private
  
      # TODO: support 'code', 'token', 'code-and-token'
      VALID_RESPONSE_TYPES = ['code']
  
      def validate_params
        if params[:client_id].blank? || params[:response_type].blank?
          redirect_to "#{params[:redirect_uri]}?error=invalid-request"
          return false
        end
    
        unless VALID_RESPONSE_TYPES.include?(params[:response_type])
          redirect_to "#{params[:redirect_uri]}?error=unsupported-response-type"
          return
        end
    
        if params[:redirect_uri].blank?
          render :text => "You did not specify the 'redirect_uri' parameter!", :status => :bad_request
          return false
        end
    
        @client = OAuthClient.find_by_client_id(params[:client_id])
    
        if @client.nil?
          redirect_to "#{params[:redirect_uri]}?error=invalid-client-id"
          return false
        end
    
        if @client.redirect_uri != params[:redirect_uri]
          redirect_to "#{params[:redirect_uri]}?error=redirect-uri-mismatch"
          return false
        end
    
        true
      end
  
    end
  end
end