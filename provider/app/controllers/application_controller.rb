# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  include SimplestAuth::Controller
  
  before_filter :login_required
  
  private
    
  def new_session_url
    url_for(:controller => 'sessions', :action => 'create')
  end
  
end
