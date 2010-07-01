class ProtectedResourceController < ApplicationController
  
  
  def index
    render :text => "current user is #{current_user.email}"
  end
  
  protected
  
  def login_required_with_oauth
    if access_token = params[:access_token]
      token = OauthToken.find_by_access_token(access_token)
      session[User.session_key] = token.user_id
    end
    
    login_required_without_oauth
  end
  
  alias_method_chain :login_required, :oauth
  
end