# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

class ProtectedResourceController < ApplicationController

  oauth_allowed :only => :index
    
  def index
    render :text => "current user is #{current_user.email}"
  end
  
  def no_oauth_here
    render :text => "this content not available via Oauth"
  end
  
end