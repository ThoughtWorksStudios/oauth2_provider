class ProtectedResourceController < ApplicationController
    
  def index
    render :text => "current user is #{current_user.email}"
  end
  
  protected
  
  def oauth_allowed?
    return action_name == 'index'
  end
  
end