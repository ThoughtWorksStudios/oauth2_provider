module SimplestAuth
  class UndefinedMethodError < StandardError; end

  module Controller
    def user_class
      User
    end

    def session_key
      user_class.session_key
    end

    def authorized?
      logged_in?
    end

    def access_denied
      store_location
      flash[:error] = login_message
      redirect_to new_session_url
    end
    
    def login_message
      "Login or Registration Required"
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def login_required
      authorized? || access_denied
    end

    def logged_in?
      !current_user_id.nil?
    end

    def current_user
      @current_user ||= begin
        if user_class.respond_to?(:find)
          user_class.find(current_user_id)
        else
          user_class.first(:id => current_user_id)
        end
      end || clear_session
    end

    def current_user=(user)
      session[session_key] = user ? user.id : nil
      @current_user = user || false
    end

    def current_user_id
      session[session_key]
    end
    
    def clear_session
      session[session_key] = nil
    end
    
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
    end
  end
end