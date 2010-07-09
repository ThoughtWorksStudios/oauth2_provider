require 'test_helper'

class ProtectedResourceControllerTest < ActionController::TestCase

  def test_access_protected_resource_with_valid_access_token
    user = User.create!(:email => "foo@example.com", :crypted_password => "Open Sesame!")
    token = Oauth2::Provider::OauthToken.create!(:user_id => user.id)
    @request.env["Authorization"] = %Q{Token token="#{token.access_token}"}
    get :index, :access_token => token.access_token
    assert_equal "current user is foo@example.com", @response.body
  end
  
  def test_access_protected_resource_with_invalid_access_token
    @request.env["Authorization"] = %Q{Token token="bogus"}
    get :index
    assert_response :unauthorized
  end
  
  def test_access_protected_resource_with_no_access_token
    get :index
    assert_redirected_to :controller => :sessions, :action => :create
  end
  
end