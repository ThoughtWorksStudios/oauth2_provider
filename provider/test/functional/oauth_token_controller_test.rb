require 'test_helper'

class OauthTokenControllerTest < ActionController::TestCase
  
  protected
  
  def assert_get_token_error(expected_error)
    assert_response :bad_request
    assert_equal "application/json; charset=utf-8", @response.headers['Content-Type']
    assert @response.headers['Cache-Control'] =~ /no-cache|private, max-age=0, must-revalidate/
    assert_equal expected_error, ActiveSupport::JSON.decode(@response.body)['error']
  end
  
end
