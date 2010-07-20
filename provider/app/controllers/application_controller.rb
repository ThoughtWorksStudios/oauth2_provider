# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  # include ApplicationController workings required for Oauth2 plugin
  include Oauth2::Provider::ApplicationControllerMethods
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  before_filter :login_required
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  def logged_in?
    !current_user.nil?
  end
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  def current_user
    @__current_user ||= User.find_by_id(session[:user_id])
  end
  
  protected
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  def login_required
    redirect_to :controller => 'sessions', :action => 'index' unless logged_in? 
  end
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  def current_user=(user)
    session[:user_id] = user.id
    @__current_user = user
  end
  
  # part of sample host app's hand-rolled  authentication 'system' :)
  def clear_current_user
    session.delete(:user_id)
    @__current_user = nil
  end

  # required by Oauth2 plugin, returns user id that will
  # serve as foreign key to authorize codes and access tokens
  def current_user_id_for_oauth
    current_user.id.to_s
  end  
  
  # required for oauth to actually work, we wrap our non-oauth
  # authentication filter with an opportunity to first determine
  # the request's user via an oauth header.
  def login_required_with_oauth
    if user_id = self.user_id_for_oauth_access_token
      session[:user_id] = user_id
    elsif looks_like_oauth_request?
      render :text => "Denied!", :status => :unauthorized
    else
      login_required_without_oauth
    end
  end
  alias_method_chain :login_required, :oauth
  
end
