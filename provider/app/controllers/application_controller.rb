# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  include SimplestAuth::Controller, Oauth2::Provider::ApplicationControllerMethods
  
  before_filter :login_required
  
  protected
  
  def login_required_with_oauth
    if user_id = self.user_id_for_oauth_access_token
      session[User.session_key] = user_id
    elsif looks_like_oauth_request?
      render :text => "Denied!", :status => :unauthorized
    else
      login_required_without_oauth
    end
  end
  alias_method_chain :login_required, :oauth
  
  def current_user_id
    super
  end
  
  private
    
  def new_session_url
    url_for(:controller => 'sessions', :action => 'create')
  end
  
end
