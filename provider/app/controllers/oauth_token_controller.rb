class OauthTokenController < ApplicationController
  
  def get_token
    token = OauthToken.find_by_authorization_code(params[:authorization_code])
    token.generate_access_token!
    render :content_type => 'application/json', :text => token.access_token_attributes.to_json
  end
  
end
