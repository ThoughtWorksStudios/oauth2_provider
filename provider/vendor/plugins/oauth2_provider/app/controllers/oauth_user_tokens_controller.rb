# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

class OauthUserTokensController < ApplicationController

  include Oauth2::Provider::SslHelper

  def index
    @tokens = Oauth2::Provider::OauthToken.find_all_with(:user_id, current_user_id_for_oauth)
  end

  def revoke
    token = Oauth2::Provider::OauthToken.find_by_id(params[:token_id])
    if token.nil?
      render :text => "You are not authorized to perform this action!", :status => :bad_request
      return
    end
    if token.user_id.to_s != current_user_id_for_oauth
      render :text => "You are not authorized to perform this action!", :status => :bad_request
      return
    end

    token.destroy
    redirect_to :action => :index
  end
  
  def revoke_by_admin
    token = Oauth2::Provider::OauthToken.find_by_id(params[:token_id])
    if token.nil?
      render :text => "You are not authorized to perform this action!", :status => :bad_request
      return
    end

    token.destroy
    
    if request.xhr?
      render :text => "Token deleted."
    else
      redirect_to :action => :index
    end
  end
    
end
