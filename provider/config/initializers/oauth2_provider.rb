module Oauth2
  module Provider

    #raise 'OAuth2 provider not configured yet!'
    # please go through the readme and configure this file before you can use this plugin!
    
    # make sure no authentication for OauthTokenController
    OauthTokenController.skip_before_filter(:login_required)
    
    # use host app's custom authorization filter to protect OauthClientsController
    # OauthClientsController.before_filter(:ensure_admin_user)
    
  end
end
