# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

class ProtectedResourceControllerTest < ActionController::TestCase

  def test_access_protected_resource_with_valid_access_token
    user = User.create!(:email => "foo@example.com", :password => "Open Sesame!")
    token = Oauth2::Provider::OauthToken.create!(:user_id => user.id)
    @request.env["Authorization"] = %Q{Token token="#{token.access_token}"}
    @request.env['HTTPS'] = 'on'
    get :index, :access_token => token.access_token
    assert_equal "current user is foo@example.com", @response.body
  end

  def test_access_protected_resource_with_invalid_access_token_using_ssl
    @request.env["Authorization"] = %Q{Token token="bogus"}
    @request.env['HTTPS'] = 'on'
    get :index
    assert_response :unauthorized
  end

  def test_access_protected_resource_with_invalid_access_token_without_ssl
    @request.env["Authorization"] = %Q{Token token="bogus"}
    assert_raise_with_message(Oauth2::Provider::HttpsRequired, "HTTPS is required for OAuth Authorizations") do
      get :index
    end
  end

  def test_access_protected_resource_with_no_access_token
    get :index
    assert_redirected_to :controller => :sessions, :action => :index
  end

end
