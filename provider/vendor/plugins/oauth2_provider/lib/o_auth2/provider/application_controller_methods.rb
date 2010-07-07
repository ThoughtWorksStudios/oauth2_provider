module OAuth2
  module Provider
    module ApplicationControllerMethods

      def self.included(controller_class)
        controller_class.cattr_accessor :oauth_options
    
        def controller_class.oauth_allowed(options = {})
          raise 'options cannot contain both :only and :except' if options[:only] && options[:except]
      
          [:only, :except].each do |k|
            if values = options[k]
              options[k] = Array(values).map(&:to_s).to_set
            end
          end
          self.oauth_options = options
        end
    
      end
      
      protected
  
      def user_id_for_oauth_access_token
        return nil unless oauth_allowed?
        header_field = request.headers["Authorization"]
        
        if header_field =~ /Token token="(.*)"/          
          token = OAuthToken.find_by_access_token($1)
          token.user_id if token
        end
      end
  
      def looks_like_oauth_request?
        !params[:access_token].blank?
      end
    
      def oauth_allowed?
        return false if oauth_options.nil?

        oauth_options.empty? || 
          (oauth_options[:only] && oauth_options[:only].include?(action_name)) ||
          (oauth_options[:except] && !oauth_options[:except].include?(action_name))
      end
  
    end
  end
end
