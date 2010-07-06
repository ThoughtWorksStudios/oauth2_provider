class ProtectedResourceController < ApplicationController

  oauth_allowed :only => :index
    
  def index
    render :text => "current user is #{current_user.email}"
  end
  
  def no_oauth_here
    render :text => "this content not available via OAuth"
  end
  
end