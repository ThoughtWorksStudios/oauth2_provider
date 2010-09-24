# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

class OauthControllerSmokeTest < ActionController::TestCase

  def setup
    @controller = OauthClientsController.new
  end

  def test_redirects_to_correct_url_when_user_is_not_logged_in
    get :index
    assert_equal 'http://test.host/', @response['Location']
    assert_redirected_to :controller => :sessions
  end

end

class OauthAuthorizeControllerSmokeTest < ActionController::TestCase

  def setup
    @controller = OauthAuthorizeController.new
  end

  def test_redirects_to_correct_url_when_user_is_not_logged_in
    get :index
    assert_equal 'http://test.host/', @response['Location']
    assert_redirected_to :controller => :sessions
  end

end
