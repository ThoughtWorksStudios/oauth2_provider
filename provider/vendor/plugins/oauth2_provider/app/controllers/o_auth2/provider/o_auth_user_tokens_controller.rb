module OAuth2
  module Provider
    class OAuthUserTokensController < ApplicationController
      
      def index
        @tokens = OAuthToken.find_all_by_user_id(current_user_id)
      end
    
    end
  end
end