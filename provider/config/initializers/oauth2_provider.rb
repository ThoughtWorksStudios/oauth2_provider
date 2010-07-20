module Oauth2
  module Provider
   
    OauthTokenController.skip_before_filter(:login_required)
    
  end
end