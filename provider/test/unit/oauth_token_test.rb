require 'test_helper'

class OauthTokenTest < ActiveSupport::TestCase
  
  def test_generate_access_token
    token = OauthToken.create!
    token.generate_access_token!
    assert_not_nil token.access_token
  end
  
end
