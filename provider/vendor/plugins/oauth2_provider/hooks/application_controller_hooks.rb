module ApplicationControllerHooks
  def self.included(controller_class)
    controller_class.class_eval do

      protected

      def login_required_with_oauth
        if user_id = user_id_for_oauth_access_token
          session[User.session_key] = user_id
        elsif looks_like_oauth_request?
          render :text => "Denied!", :status => :unauthorized
        else
          login_required_without_oauth
        end
      end
      alias_method_chain :login_required, :oauth
      
    end
  end
end

ApplicationController.send :include, ApplicationControllerHooks
